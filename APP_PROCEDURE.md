## Application Procedure
### Term
- Token: ユーザーが発行するToken
- Maker: Trade情報を作成する人
- Taker: Trade情報を元にTokenを購入するユーザー
- Indexer: Trade情報を掲載しているDB

### App flow

#### Sing up
- usernameとpasswordを入力してsing upを行う。

<div align="center">
  <img src="./public/procedure/singin.png" width=70%>
</div>

#### Issue token
- 「Token Issue」ボタンをクリックする。

<div align="center">
  <img src="./public/procedure/top.png" width=70%>
</div>

#### Input token information
- symbol、name、発行量の情報を入力してTokenを発行する。  
  （name: TEST, symbol: TST, Totaltokens: 1000 ）

  <div align="center">
    <img src="./public/procedure/token-create.png" width=70%>
  </div>

#### Create result
- Tokenが発行される。

<div align="center">
  <img src="./public/procedure/token-create-result.png" width=70%>
</div>

#### Create other token
- 別のユーザーでログインしてもう一つTokenを発行する。  
  （name: EXAM, symbol: EXE, Totaltokens: 2000 ）
<div align="center">
  <img src="./public/procedure/other-token-create.png" width=70%>
</div>

#### Input trade information
- makerはTrade情報を入力する。
  - from, to: どのTokenをトレードしたいか
  - Price: トレードに出す自分のToken（maker_token）の値段を入力
  - Amount: トレードに出す自分のTokenの総量を入力  
    ※ MakerはPrice×AmountのToken（taker_token）を購入することができる

<div align="center">
  <img src="./public/procedure/token-trade-info-create.png" width=70%>
</div>

#### Create result
- Trade情報が反映される。

<div align="center">
  <img src="./public/procedure/token-trade-info.png" width=70%>
</div>

#### Buy token
- TakerはTrade情報から購入するTokenを選び、購入するTokenの量を入力する。

<div align="center">
  <img src="./public/procedure/trade.png" width=70%>
</div>

#### Trade result
- Tradeが成功すると、ユーザーの所有しているToken情報が更新される。

<div align="center">
  <img src="./public/procedure/trade-result.png" width=70%>
</div>

- Trade情報も同様に更新される。

<div align="center">
  <img src="./public/procedure/trade-info-update.png" width=70%>
</div>
