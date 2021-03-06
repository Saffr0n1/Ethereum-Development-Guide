# Ethereum Development Guide

This document is an (ongoing) introduction to blockchain, Ethereum, smart contracts, and DeFi. The following resources were used in my own learning and many of their points are synthesized here:
- [Solidity Docs](https://docs.soliditylang.org/en/v0.8.11/index.html)
- [Finematics](https://finematics.com)
- [Truffle](https://trufflesuite.com)
- [Hardhat](https://hardhat.org)
- [Brownie](https://eth-brownie.readthedocs.io/en/stable/)

# Contents

- [1. Blockchain Overview](#1-blockchain-overview)
  - [1.1. Why use blockchains](#11-why-use-blockchains)
  - [1.2 What is a blockchain](#12-what-is-a-blockchain)
    - [1.2.1 Blockchain basics](#121-blockchain-basics)
  - [1.3 Cryptography](#13-cryptography)
  - [1.4 The Ethereum blockchain](#14-the-ethereum-blockchain)
  - [1.4.1 What is a smart contract](#141-what-is-a-smart-contract)
  - [1.4.2 Ethereum networks](#142-ethereum-networks)
- [2. Solidity Basics](#2-solidity-basics)
  - [2.1 Types](#21-types)
    - [2.1.1 Address types](#211-address-types)
    - [2.1.2 Contract types](#212-contract-types)
    - [2.1.3 Enums](#213-enums)
    - [2.1.4 User defined value types](#214-user-defined-value-types)
  - [2.2 Reference types](#22-reference-types)
    - [2.2.1 Arrays](#221-arrays)
  - [2.3 Cheatsheet](#23-cheatsheet)
- [3. Introduction to Truffle](#3-introduction-to-truffle)
  - [3.1 Creating a Truffle project](#31-creating-a-truffle-project)
  - [3.2 Compiling smart contracts](#32-compiling-smart-contracts)
  - [3.3 Local environment setup](#33-local-environment-setup)
  - [3.4 Migrations](#34-migrations)
  - [3.5 Interfacing with a smart contract](#35-interfacing-with-a-smart-contract)

# 1. Blockchain Overview

## 1.1. Why use blockchains

Blockchains are used when multiple parties need to share data and transfer value without trusting each other.

The financial world describes this trust as the **counterparty risk**: the risk that the other party won't hold up their end of the bargain. Blockchains completely remove the counterparty risk through a revolutionary system of mathematics, cryptography, and peer-to-peer networking.

## 1.2 What is a blockchain

A blockchain is a shared database consisting of a ledger of transactions. Each connected device that has a copy of the ledger is called a **node**. Blockchains offer the following key features:
- **Full Decentralization:** Reading/writing to the database is decentralized and secure. 
- **Fault Tolerance:** Every account that shares the database has to validate changes, meaning the system is able to handle corrupt data. 
- **Independent Verification:** Transactions can be verified by ayone without the need for a third party. 

### 1.2.1 Blockchain basics

Although these concepts are true broadly, we focus on the Ethereum blockchain. 

Interactions between accounts in a blockchain network are called transactions. A bundle of transactions is called a block. Every account on the blockchain has a unique signature, which lets everyone know which account initiated a transaction. On a public blockchain, anyone can read or write data. Reading data is free, but writing to the public blockchain is not. This cost, known as **gas**, helps discourage spam and pays to secure the network.

**Mining:** Any node on the network can take part in securing the network through a process called mining. Nodes which have opted to be miners compete to solve math problems which secure the contents of a block. Since mining requires computing power (not to mention electricity cost), miners can be compensated for their service. The winner of the competition receives some cryptocurrency as a reward. 

**Hashing:** Once a new block is mined, the other miners are notified and begin verifying and adding this new block to their copies of the chain. This is done through cryptographic hashing. Hashing is an approximately one-way process which takes in data and gives back a fixed-length string representing that data. While the original data can't be reproduced from its hash, the same data will always produce the same hash. Therefore, unverified data can be hashed with the same function and compared to the original. If they are identical, the data is validated. Once more than half of the miners have validated the new block, the network has **reached consensus** and the block becomes part of the blockchain permanent history. Now this data can be downloaded by all nodes, with its validity assured.

## 1.3 Cryptography

Although not at all necessary, I recommend learning more about the mathematics of cryptography. I recommend Boaz Barak's [An Intensive Introduction to Cryptography](https://intensecrypto.org/public/index.html), which we used for CS 227 at Harvard. 

## 1.4 The Ethereum blockchain

Ethereum is a blockchain that allows you to run programs in its trusted environment. This contrasts with the Bitcoin blockchain, which only allows you to manage cryptocurrency. To this end, Ethereum has a virtual machine, called the Ethereum Virtual Machine (EVM). The EVM allows code to be verified and executed on the blockchain, providing guarantees it will be run the same way on everyone's machine. This code is contained in **smart contracts**. Beyond just tracking account balances, Ethereum maintains the state of the EVM on the blockchain. All nodes process smart contracts to verify the integrity of the contracts and their outputs.

## 1.4.1 What is a smart contract

Smart contracts are code that run on the EVM. THey can accept and store *ether* and data and can distribute that ether to other accounts or other smart contracts. Smart contracts are written in a language called **Solidity**, which we'll learn about later. 

## 1.4.2 Ethereum networks

The main Ethereum blockchain, called the MainNet, is a public blockchain where all data is visible and anyone can create a node and begin verifying transactions. Ether on this network has a market value and can be exchanged for other assets. 

**Local Test Networks**

Local test networks process simulate the Ethereum blockchain locally on a device, allowing for transactions to be processed instantly and for Ether to be distributed arbitrarily. 

**Public Test Networks:**

Public test nets are used to test Ethereum applications before final deployment to the MainNet. Common public test nets are:
- Kovan
- Ropsten
- Rinkeby

# 2. Solidity Basics

The full documentation for Solidity can be found [here](https://docs.soliditylang.org/en/v0.8.11/index.html). 

Consider the following simple example

```
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
```

The first line is a machine-readable **SPDX License Identifier**, more details about which can be found [here](https://spdx.dev).

The `pragma` keyword is used to establish some compiler checks. In the example above, there is a **version pragma**, which rejects compilation with future versions that may introduce incompatible changes. 

A state variable called `storedData` of type `uint` is then declared. The functions `set()` and `get()` are provided and can be queried to alter `storedData`.

## 2.1 Types

These are just some points that may differ from other languages, for the full description, check out the [docs](https://docs.soliditylang.org/en/v0.8.11/types.html#value-types).

**Booleans:** `bool` can take on `true` or `false`. Boolean operators are:
- `!` negation
- `&&` and
- `||` or
- `==` equality
- `!=` inequality

**Integers:** `int/uint` refer to signed and unsigned integers. Default size is 256 bits, although any 8 bit increment can be used `int8 -> int256` and `uint8 - uint256`.


**Negating an expression:**The expression `-x` is equivalent to `T(0)-x` where `T` refers to the type of `x`. This can only be applied to signed types. In addition, note that all arithmetic is checked for over/underflow by default, although this can be disabled. 

**Division:** Since the type of the result of an operation is always the type of one of the operands, division on integers always results in an integer. In Solidity, division rounds towards zero.

### 2.1.1 Address types

The address type has two forms:
- `address`: Holds a 20-byte value (which is the size of an Ethereum address)
- `address payable`: Same as `address` but with additional members `transfer` and `send`

Implicit conversions allowed:
- `address payable` to `address`
- To and from `address` and `uint160`, integer literals, `bytes20`, and contract types
  
Explicit conversions required:
- `address` or contract types to `address payable` via `payable(<address>)`

### 2.1.2 Contract types

Every contract defines its own type. One can implicitly convert contracts to contracts that they inherit from. In addition, contracts can be explicitly converted to and from the `address` type. 

### 2.1.3 Enums

Enums are one way to create a user-defined type in Solidity. They are explicitly convertible to and from all integer types but implicit conversion is not allowed. The explicit conversion from integer checks at runtime that the value lies inside the range of the enum and causes a **Panic error** otherwise. Enums require at least one member, and its default value when declared is the first member. Enums cannot have more than 256 members.

### 2.1.4 User defined value types

A user defined value type allows creating a zero cost abstraction over an elementary value type. This is similar to an alias, but with stricter type requirements.

A user defined value type is defined using `type C is V`, where `C` is the name of the newly introduced type and `V` has to be a built-in value type (the ???underlying type???). The function `C.wrap` is used to convert from the underlying type to the custom type. Similarly, the function `C.unwrap` is used to convert from the custom type to the underlying type.

## 2.2 Reference types

If you use a reference type, you always have to explicitly provide the data area where the type is stored: `memory` (whose lifetime is limited to an external function call), `storage` (the location where the state variables are stored, where the lifetime is limited to the lifetime of a contract) or `calldata` (special data location that contains the function arguments).

### 2.2.1 Arrays

Arrays either have compile-time fixed size, `T[k]` or dynamic size `T[]` where `T` is the element type of the array. 

In Solidity, `X[k]` always means an array containing three elements of type `X`, even if `X` is itself an array. Thus, higher dimension arrays can be constructed as `T[][k]`. 


## 2.3 [Cheatsheet](https://docs.soliditylang.org/en/v0.8.11/cheatsheet.html)

# 3. Introduction to Truffle

Truffle is a development and testing environment for Ethereum. Installation instructions can be found on the [Github repo](https://github.com/trufflesuite/truffle).

To configure, first install Node.js and Git. Then, install truffle using
```
npm install -g truffle
```

## 3.1 Creating a Truffle project

To create a project, first make a directory
```
mkdir <project name>
cd <project name>
```
Then, either create a barebones Truffle project with
```
truffle init
```
Or utilize existing boilerplate by calling 
```
truffle unbox <box-name>
```
These commands will result in a project strurcture containing
- `contracts/`: A directory for Solidity smart contracts
- `migrations/`: A directory for scriptable deployment files
- `test/`: A directory for test files
- `truffle.js`: A Truffle configuration file

## 3.2 Compiling smart contracts

Solidity is a compiled language, meaning we need to compile our Solidity to bytecode for the EVM. To compile, move to the root of your project directory and run
```
truffle compile
```
On your first run, this command will compile all contracts and on subsequent runs, will only compile changed contracts. This behavior can be overridden by calling
```
truffle compile --all
```

## 3.3 Local environment setup

Before being able to migrate contracts to the blockchain, a local blockchain needs to be running. A good option when using Truffle is to run [Ganache](https://trufflesuite.com/ganache/), which will generate a blockchain running locally on port 7545. 

## 3.4 Migrations

A migration is a deployment script meant to alter the state of your application's contracts, moving it from one state to the next. These files are responsible for staging your deployment tasks, and they're written under the assumption that your deployment needs will change over time. As your project evolves, you'll create new migration scripts to further this evolution on the blockchain. To run migrations, call
```
truffle migrate
```
To run all migrations from the beginning, call
```
truffle migrate --reset
```

## 3.5 Interfacing with a smart contract

After deploying a smart contract locally and interacting with it via the console, it may be desirable to create a front-end so that users can interact with the contract. Refer to the **pet-shop-tutorial** folder and look at **app.js** to see how instantiating web3 and the contract work. In the directory, the **src** folder contains the genral front-end code. 




