//Part 3:


mapf1 = function() {
   for (items.qty of this.orders) {
    emit(items.qty, {qtySum:qty, qty_count:1} );
  }
}

reducef1 = function(key, values) {
  sum = 0;
  count = 0;
  for (x of values) {
    sum = sum + x.qtySum;
    count = count + x.qty_count;
  }
  return {qtySum:sum, qty_count:count}
}

db.orders.mapReduce(mapf1, reducef1, {out:"temp1"})

mapf2 = function() {
  for (address.zip of this.customers){
    emit(this.address.zip, {name:this.name});
  }
}

reducef2 = function(key, values) {
  sum = 0;
  count = 0;
  name = "";
  for (x of values) {
    if ("qtySum" in x) {
      sum = sum + x.qtySum;
      count = count + x.qty_count;
    }
    if ("name" in x) {
      name = x.name;
    }
  }
  return {qty_sum:sum, qty_count:count, name:name}
}

db.customers.mapReduce(mapf2, reducef2, {out: {reduce:"temp1"}}); 

mapf3 = function() {
  emit(this.value.name, {qtySum:this.value.qrySum, qty_count:this.value.qty_count}) 
}

reducef3 = function(key, values) {
  sum=0;
  count=0;
  for (x of values) {
    sum = sum + x.qtySum;
    count = count + x.qty_count;
  }
  return {qtySum:sum, qty_count: count, average:sum/count}
}

print("zip and quantity sold")
db.temp1.mapReduce(mapf3, reducef3, {out:"temp2"})
q = db.temp2.find();
while ( q.hasNext() ){
  printjson(q.next());
}
