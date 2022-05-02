// 基本示例
// bad
request(url, function(err, res, body){
	if (err) handleError(err);
	fs.writeFile('1.txt', body, function(err){
		request(url2, function(err, res, body){
			if (err) handleError(err);
		})
	})
})

// good
request(url)
.then(function(result){
	return writeFileAsync('1.txt', result);
})
.then(function(result){
	return request(url2);
})
.catch(functione(){
	handleError(e);
})

// finally
fetch('file.json')
.the(data => data.json())
.catch(err => console.error(error))
.finally(() => console.log('finish'))

