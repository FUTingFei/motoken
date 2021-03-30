# motoken

## abstract

这是一个用 motoko 实现的的 token 代码。token 名为 motoken，符号为 MTK，小数位为 0，总量为 1000

## steps

terminal 1:
```
dfx start 
```

terminal 2:
```shell

npm install

dfx deploy

dfx identity new alice_auth
dfx identity new bob_standard

DEFAULT_ID="principal \"$(dfx --identity default identity get-principal | sed 's/[\\(\\)]//g')\""
ALICE_ID=$(dfx --identity alice_auth canister call motoken callerPrincipal | sed 's/[\\(\\)]//g')
BOB_ID=$(dfx --identity bob_standard canister call motoken callerPrincipal | sed 's/[\\(\\)]//g')

echo $DEFAULT_ID
echo $ALICE_ID
echo $BOB_ID

dfx canister call motoken init '("motoken", "MT", 0, 1000)'

dfx canister call motoken balanceOf "($ALICE_ID)"
dfx canister call motoken transfer "($ALICE_ID, 500)"

dfx canister call motoken totalSupply 

dfx canister call motoken balanceOf "($DEFAULT_ID)"
dfx canister call motoken balanceOf "($ALICE_ID)"

dfx canister call motoken approve "($ALICE_ID, 300)"

dfx --identity alice_auth canister call motoken transferFrom "($DEFAULT_ID, $BOB_ID, 500)"

dfx canister call motoken balanceOf "($ALICE_ID)"

dfx canister call motoken balanceOf "($BOB_ID)"

dfx canister call motoken balanceOf "($DEFAULT_ID)"
```

## reference
1. ERC20: https://eips.ethereum.org/EIPS/eip-20