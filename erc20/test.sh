#!/bin/bash

# 脚本只要发生错误，就终止执行
set -e

# 清理环境并启动本地副本
dfx stop
rm -rf .dfx
dfx start --background


# 部署脚本
npm install
dfx deploy

# 创建身份并保存为变量
dfx identity new alice_auth
dfx identity new bob_standard

# default 身份部署时已自动创建
DEFAULT_ID="principal \"$(dfx --identity default identity get-principal | sed 's/[\\(\\)]//g')\""
ALICE_ID=$(dfx --identity alice_auth canister call motoken callerPrincipal | sed 's/[\\(\\)]//g')
BOB_ID=$(dfx --identity bob_standard canister call motoken callerPrincipal | sed 's/[\\(\\)]//g')

echo default id = $DEFAULT_ID
echo alice id = $ALICE_ID
echo bob id = $BOB_ID

# 代币初始化
echo 
echo == token initializing ==
echo 
eval dfx canister call motoken init "'(\"motoken\", \"MTK\", 0, 10000)'"

# 转账
echo 
echo == transfer ==
echo

echo Total Supply = $( eval dfx canister call motoken totalSupply )
echo Default = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Alice = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Bob = $( eval dfx canister call motoken balanceOf "'($BOB_ID)'" )

echo 
echo == transfer 500 tokens from default to alice ==
echo 

eval dfx canister call motoken transfer "'($ALICE_ID, 500)'"

echo Total Supply = $( eval dfx canister call motoken totalSupply )
echo Default = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Alice = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Bob = $( eval dfx canister call motoken balanceOf "'($BOB_ID)'" )

echo 
echo == transfer 200 tokens from alice to bob ==
echo 

eval dfx --identity alice_auth canister call motoken transfer "'($BOB_ID, 200)'"

echo Total Supply = $( eval dfx canister call motoken totalSupply )
echo Default = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Alice = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Bob = $( eval dfx canister call motoken balanceOf "'($BOB_ID)'" )

echo 
echo == transfer 100 tokens from bob to default ==
echo 

echo Total Supply = $( eval dfx canister call motoken totalSupply )
echo Default = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Alice = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Bob = $( eval dfx canister call motoken balanceOf "'($BOB_ID)'" )

# 授权转账

echo == allowance ==

echo 
echo == allow alice 100 tokens to transfer ==
echo 

eval dfx canister call motoken approve "'($ALICE_ID, 100)'"

echo 
echo == transfer 50 tokens from default to bob by alice ==
echo

eval dfx --identity alice_auth canister call motoken transferFrom "'($DEFAULT_ID, $BOB_ID, 50)'"

echo Total Supply = $( eval dfx canister call motoken totalSupply )
echo Default = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Alice = $( eval dfx canister call motoken balanceOf "'($ALICE_ID)'" )
echo Bob = $( eval dfx canister call motoken balanceOf "'($BOB_ID)'" )

echo 
echo == test over ==
echo 