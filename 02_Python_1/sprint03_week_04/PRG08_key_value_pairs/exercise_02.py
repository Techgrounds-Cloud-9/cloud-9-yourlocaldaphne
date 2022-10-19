import csv
from re import A


info = ["First name", "Last name", "Job title", "Company"]

first_name = (input("Enter your first name:"))
last_name = input("Enter your last name:")
job_title = input("Enter your job title:")
company = input("Enter your company:")

Dict = [{
    "First name": first_name,
    "Last name": last_name,
    "Job title": job_title,
    "Company": company
    }]

print(Dict)

csv_file = open('exercise_02.csv', 'a')

writer = csv.writer(csv_file)
writer.writerow(Dict.values())
csv_file.close()
csv_file = open('exercise_02.csv', 'a')
print(csv_file.read())

