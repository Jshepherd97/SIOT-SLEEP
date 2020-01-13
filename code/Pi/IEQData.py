# Imports
import sys
import urllib2
import time
import requests
import csv
import json
from github import Github, InputGitTreeElement
from datetime import datetime
from bme280 import BME280
from enviroplus import gas
try:
    from smbus2 import SMBus
except ImportError:
    from smbus import SMBus
try:
    # Transitional fix for breaking change in LTR559
    from ltr559 import LTR559
    ltr559 = LTR559()
except ImportError:
    import ltr559

myAPI = 'QHIMOBQM3MZZ15IH'
baseURL = 'https://api.thingspeak.com/update?api_key=%s' % myAPI

# Bme280 Setup
bus = SMBus(1)
bme280 = BME280(i2c_dev=bus)

# Get the temperature of the CPU for compensation
def get_cpu_temperature():
    with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
        temp = f.read()
        temp = int(temp) / 1000.0
    return temp

# Tuning factor for compensation. Decrease this number to adjust the
# temperature down, and increase to adjust up
factor = 2.25
cpu_temps = [get_cpu_temperature()] * 5

# Bme280 reading
def logSensor(cpu_temps):
    cpu_temp = get_cpu_temperature()
    # Smooth out with some averaging to decrease jitter
    cpu_temps = cpu_temps[2:] + [cpu_temp]
    avg_cpu_temp = sum(cpu_temps) / float(len(cpu_temps))
    raw_temp = bme280.get_temperature()
    temperature = raw_temp - ((avg_cpu_temp - raw_temp) / factor)
    # temperature = bme280.get_temperature()
    pressure = bme280.get_pressure()
    humidity = bme280.get_humidity()
    lux = ltr559.get_lux()
    readings = gas.read_all()
    reducing = readings.reducing
    oxidising = readings.oxidising
    nh3 = readings.nh3

    return([temperature, pressure, humidity, lux, reducing, oxidising, nh3])

# write data 
def writeData():
  now = datetime.now().strftime("%d/%m/%Y %H:%M")
  sensorData1 = logSensor(cpu_temps)
  time.sleep(5)
  sensorData2 = logSensor(cpu_temps)
  time.sleep(5)
  sensorData3 = logSensor(cpu_temps)
  time.sleep(5)
  sensorData4 = logSensor(cpu_temps)
  time.sleep(5)
  sensorData5 = logSensor(cpu_temps)
  sensorDataT = [x + y + m + n + s for x,y,m,n,s in zip(sensorData1, sensorData2, sensorData3, sensorData4, sensorData5)]
  sensorData = [c / 5 for c in sensorDataT] 
  allData = [now] + sensorData
  with open('data/allData.csv', 'a', ) as file:
    writer = csv.writer(file)
    writer.writerow(allData)
    print('Data written to CSV file')
  try:  
    conn = urllib2.urlopen(baseURL + '&field1=%s&field2=%s&field3=%s&field4=%s&field5=%s&field6=%s&field7=%s' % (sensorData[0], sensorData[1], sensorData[2], sensorData[3], sensorData[4], sensorData[5], sensorData[6]))
    print('Data uploaded to thingspeak')
    conn.close
  except:
    print('WARNING: Could not push data to thingspeak. Storing locally until next data capture.')

# GitHub push function from stackoverflow.com/questions/50071841/
def pushData(token='54fcce38d86948e80bd49426c9793ec406c7c7e6'):
  g = Github(token)
  repo = g.get_user().get_repo('SIOT-SLEEP')
  file_list = [
    'data/allData.csv'
  ]
  commit_message = 'AUTO: Datapoint added'
  master_ref = repo.get_git_ref('heads/master')
  master_sha = master_ref.object.sha
  base_tree = repo.get_git_tree(master_sha)
  element_list = list()
  for i, entry in enumerate(file_list):
      with open(entry) as input_file:
          data = input_file.read()
      element = InputGitTreeElement(file_list[i], '100644', 'blob', data)
      element_list.append(element)
  tree = repo.create_git_tree(element_list, base_tree)
  parent = repo.get_git_commit(master_sha)
  commit = repo.create_git_commit(commit_message, tree, [parent])
  master_ref.edit(commit.sha)
  print('Data pushed to GitHub')

# Begin main function
print('Starting data collection, use CTRL+C to cancel')
currentminute = int(datetime.now().strftime("%M"))
targetminute = currentminute

while True:
  currentminute = int(datetime.now().strftime("%M"))
  if currentminute == targetminute:
    print('Logging data at ' + datetime.now().strftime("%d/%m/%Y %H:%M"))
    writeData()
    if (currentminute == 0) or (currentminute == 30):
      try:  
        pushData()
      except:
        print('WARNING: Could not push data to Github. Storing locally until next data capture.')
    if currentminute == 59:
      targetminute = 0
    else:
      targetminute = currentminute + 1
    print('Next data log to be taken at {} minute'.format(targetminute))
  else:
    time.sleep(20) 

