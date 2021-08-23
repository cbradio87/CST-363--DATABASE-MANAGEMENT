//Part 2

mapf = function() {
	if(this.address.zip > 89999){
	emit(this.address.zip, 1);
	}
}

reducef = function(key, values) {
	total=0
	for (x of values) {
		total=total+x;
		}
	return total;
}

db.customers.mapReduce( mapf, reducef, {out: "out_collection"});


cursor = db.out_collection.find();
while (cursor.hasNext()) {
	printjson(cursor.next());
}


