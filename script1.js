//part one
//1:

db.createCollection('patients');

//2:
db.patients.insertMany([
{"first_name":"Janet", "last_name":"Smith", "ssn": "123-12-1234", "age": 10, "address" : "2009 N. Lyon St."},
{"first_name" : "tom", "last_name": "Duke", "ssn" : "132-21-2343", "age": 20, "address" :"17621 E. 17th St."},
{"first_name": "Jennifer", "last_name" : "Nelson", "ssn" : "432-23-2132", "age" : 30, "addresss" : "10 1st St.", 
"prescriptions" : [{"id": "RX743009", "tradename": "Hydrochlorothiazide"},
{"id" : "RX656003", "tradname": "LEVAQUIN", "formula" : "levofloxacin"}]}]);

//3:
db.patients.find()

//4:
db.patients.find({age: 20});

//5:
db.patients.find( {age: {"$lt": 25}});

//6:
db.patients.drop()

//7:
//C:\mongodb\mongodb-win32-x86_64-windows-4.4.6\bin>mongo script1.js

//8:
doca = db.col.findOne({name:"tom"})
print("Document with name tom")
printjson(doca)

//9:
cursor = db.col.find({name: "tom"})
print("Displaying all documents with name tom")
while (cursor.hasNext()){
	printjson(cursor.next())
}