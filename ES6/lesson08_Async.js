// 代码更简洁
// good
function fetch() {
  return (
    fetchData()
    .then(() => {
      return "done"
    });
  )
}

// better
async function fetch() {
  await fetchData()
  return "done"
};

// 2.
// good
function fetch() {
  return fetchData()
  .then(data => {
    if (data.moreData) {
        return fetchAnotherData(data)
        .then(moreData => {
          return moreData
        })
    } else {
      return data
    }
  });
}

// better
async function fetch() {
  const data = await fetchData()
  if (data.moreData) {
    const moreData = await fetchAnotherData(data);
    return moreData
  } else {
    return data
  }
};

// 3.
// good
function fetch() {
  return (
    fetchData()
    .then(value1 => {
      return fetchMoreData(value1)
    })
    .then(value2 => {
      return fetchMoreData2(value2)
    })
  )
}

// better
async function fetch() {
  const value1 = await fetchData()
  const value2 = await fetchMoreData(value1)
  return fetchMoreData2(value2)
};

// 错误处理
// good
function fetch() {
  try {
    fetchData()
      .then(result => {
        const data = JSON.parse(result)
      })
      .catch((err) => {
        console.log(err)
      })
  } catch (err) {
    console.log(err)
  }
}

// better
async function fetch() {
  try {
    const data = JSON.parse(await fetchData())
  } catch (err) {
    console.log(err)
  }
};

// `Async`地狱：
// bad
(async () => {
  const getList = await getList();
  const getAnotherList = await getAnotherList();
})();

// good
(async () => {
  const listPromise = getList();
  const anotherListPromise = getAnotherList();
  await listPromise;
  await anotherListPromise;
})();

// good
(async () => {
  Promise.all([getList(), getAnotherList()]).then(...);
})();


