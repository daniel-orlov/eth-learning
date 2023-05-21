const HelloWorld = artifacts.require("HelloWorld");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("HelloWorld", function () {
  it("should return message 'Hello World'", function () {
    return HelloWorld.deployed().then(function (instance) {
      return instance.getMessage.call();
    }).then(function (message) {
        assert.equal(message.valueOf(), "Hello World", "Message is not 'Hello World'");
    });
  });
  it("should update message to 'Hello Ethereum'", function () {
    let helloWorld;
    return HelloWorld.deployed().then(function (instance) {
      helloWorld = instance;
      return helloWorld.update("Hello Ethereum");
    }).then(function () {
      return helloWorld.getMessage.call();
    }).then(function (message) {
      assert.equal(message.valueOf(), "Hello Ethereum", "Message is not 'Hello Ethereum'");
    });
  });
});
