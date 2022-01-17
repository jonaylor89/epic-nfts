# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

# ✈️ A note on contract redeploys

Let's say you want to change your contract. You'd need to do 3 things:

- We need to deploy it again.
- We need to update the contract address on our frontend.
- We need to update the abi file on our frontend.