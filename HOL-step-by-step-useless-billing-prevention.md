![Microsoft Cloud Workshop](images/ms-cloud-workshop.png)

Useless Billing Prevention
Hands-on lab  
October 2021

## To Do

- 2-2 ログインできない問題

<br />

**Contents**

## **1. 仮想マシン停止の自動化**

- **本手順では、仮想マシンを自動停止する手順を実行します。仮想マシンが起動していることを確認してから、以下の手順を進めてください。**

- 作成した仮想マシンを選択

- **自動シャットダウン**を選択し、以下の項目を入力

    - スケジュールされたシャットダウン: `0:00:00`
    - タイムゾーン: `(UTC+09:00 大阪、札幌、東京)`
    - 自動シャットダウンの前に通知を送信しますか?: `はい`
    - 電子メールアドレス: 通知を送信したいメールアドレスを入力

![alt text](./images/01-vm-auto-shutdown.png)

- **保存**をクリック

## **2. Azure Automation を用いた仮想マシン起動・停止の自動化**

### **2-1. カスタム Runbook を作成**

```
本手順では、PowerShell によるスクリプトを作成し、仮想マシンの起動・停止を自動化するスクリプトを実行します。ハンズオン内では、仮想マシンを自動停止するスクリプトを使用します
```

- 作成した Automation アカウントを選択

- **Runbook** を選択し、以下の項目を入力

    - 名前: `StopVMDaily`
    - Runbook の種類: `PowerShell`
    - 説明: `仮想マシンを日次で停止するための Runbook。`

![alt text](./images/02-automation-create-runbook.png)

- `./scripts/StopVMDaily.ps1` のスクリプトをコピー & ペーストし、**保存**をクリック

![alt text](./images/02-automation-save-runbook.png)

- **公開**をクリック

- **スケジュールの追加**をクリック

![alt text](./images/02-automation-add-schedule.png)

- **スケジュールを Runbook にリンクします**をクリック

![alt text](./images/02-automation-link-schedule-to-runbook.png)

- **スケジュールの追加**をクリック

![alt text](./images/02-automation-add-schedule-add-schedule.png)

- 以下の項目を入力し、**作成**をクリック

    - 名前: `every-midnight`
    - 説明: `毎晩 0:00`
    - 開始時: `任意の日付 0:00`
    - タイムゾーン: `Japan - Japan Time`
    - 繰り返し: `定期的`
    - 間隔: `1 日`
    - 有効期限の設定: `いいえ`

![alt text](./images/02-automation-add-schedule-add-schedule-new-schedule.png)

- **OK** をクリック

![alt text](./images/02-automation-add-schedule-create.png)

- **開始**をクリック（テスト実行）

![alt text](./images/02-automation-execute-runbook.png)

- ジョブが**失敗**していることを確認

![alt text](./images/02-automation-check-job-has-failed.png)

- Automation アカウントに対してシステム割り当てマネージド ID を有効化

![alt text](./images/02-automation-enable-managed-identity.png)

- **ロールの割り当て**をクリック

![alt text](./images/02-automation-assign-role-to-managed-identity.png)

- <b>ロールの割り当ての追加(プレビュー)</b>をクリック

![alt text](./images/02-automation-assign-role-to-managed-identity-add-role.png)

- 以下の項目を入力し、**保存**をクリック

    - スコープ: `サブスクリプション`
    - サブスクリプション: ワークショップで使用するサブスクリプション
    - 役割: `仮想マシン共同作成者`

- **開始**をクリック（再びテスト実行）

![alt text](./images/02-automation-execute-runbook.png)

- **出力**タブでログを確認し、`Status` が `Succeeded` になっていることを確認

```log
OperationId : 9c42c7b0-d69f-4bed-b564-5109cbad0e8e
Status      : Succeeded
StartTime   : 10/7/2021 6:49:02 AM
EndTime     : 10/7/2021 6:49:48 AM
Error       : 
Name        : 
```

![alt text](./images/02-automation-execute-runbook-output.png)

### **2-2. Runbook ギャラリーからスクリプトをインポート**

```
Azure Automation で独自の Runbook およびモジュールを作成するのではなく、マイクロソフトやコミュニティによって既に作成されているシナリオにアクセスできます。
本手順では、ギャラリーを参照し、 Runbook のインポートのみを行います。
```

- **ギャラリーを参照**をクリック

![alt text](./images/02-automation-execute-runbook.png)

- **Stop-Start-AzureVM (Scheduled VM Shutdown/Startup)** をクリック

![alt text](./images/02-automation-search-stop-start-azurevm.png)

- **インポート**をクリック

![alt text](./images/02-automation-search-stop-start-azurevm-import.png)

- 以下の項目を入力し、**OK** をクリック

    - 名前: `Stop-Start-AzureVM`
    - Runbook の種類: `PowerShell ワークフロー`（変更不可）
    - 説明: 既定値

![alt text](./images/02-automation-import-stop-start-azurevm.png)

## **3. Azure Functions を用いた仮想マシン起動・停止の自動化**

- **本手順では、仮想マシンを自動起動するスクリプトを使用します。仮想マシンが停止していることを確認してから以下の手順を進めてください。**

-. システム割り当てマネージド ID を有効化し、**保存**をクリック

![alt text](./images/03-functions-enable-managed-identity.png)

- **ロールの割り当て**をクリック

![alt text](./images/03-functions-assign-role-to-managed-identity-add-role.png)

- <b>ロールの割り当ての追加(プレビュー)</b>をクリック

![alt text](./images/02-automation-assign-role-to-managed-identity-add-role.png)

- 以下の項目を入力し、**保存**をクリック

    - スコープ: `サブスクリプション`
    - サブスクリプション: ワークショップで使用するサブスクリプション
    - 役割: `仮想マシン共同作成者`

- 以下の環境変数を追加し、**保存**をクリック

    - resourceGroup: `<起動対象の仮想マシンが存在するリソースグループ名>`

    ![alt text](./images/03-functions-add-environment-variables.png)

- ローカル PC にて Visual Studio Code を起動

![alt text](./images/03-functions-open-vscode.png)

- Azure Functions 拡張機能から、関数を作成

    - **Create Function** をクリックし、**Timer Trigger** を選択

    ![alt text](./images/03-functions-create-function.png)

    - **StartVMs** を入力

    ![alt text](./images/03-functions-create-function-input-folder-name.png)

    - スケジュールとして `0 30 8 * * *` を入力

    ![alt text](./images/03-functions-create-function-input-schedule.png)

- `host.json` の `managedDependency` が有効化されていることを確認

```json
・・・
"managedDependency": {
    "enabled": true
  },
・・・
```

- `host.json` の末尾に以下を追記

```json
・・・
  "functionTimeout": "00:10:00"
```

- `requirements.psd1` の以下をアンコメント

```ps1
    'Az' = '6.*'
```

- `StartVMs/run.ps1` を `./functions/StartVMs/run.ps1` の内容に書き換え

- Azure Functions 拡張機能から、関数をデプロイ

    - **Deploy to Function App** をクリック

    ![alt text](./images/03-functions-deploy-function.png)

    - Azure Functions が存在するサブスクリプションを選択

    ![alt text](./images/03-functions-deploy-function-pick-subscription.png)

    - `function-handson-lab-japaneast-001` を選択

    ![alt text](./images/03-functions-deploy-function-select-functions.png)

    - `Deploy` を選択

    ![alt text](./images/03-functions-deploy-function-deploy.png)

- Azure Portal から **StartVMs** を選択

![alt text](./images/03-functions-test-function.png)

- **コードとテスト**タブから**実行**をクリック

![alt text](./images/03-functions-test-function-2.png)

- 出力されるログにて、`StatusCode: Accepted` となっていることを確認

```log
2021-10-10T07:49:47.170 [Information] OUTPUT: RequestId                            IsSuccessStatusCode StatusCode ReasonPhrase
2021-10-10T07:49:47.170 [Information] OUTPUT: ---------                            ------------------- ---------- ------------
2021-10-10T07:49:47.172 [Information] OUTPUT: 7a40a0a0-86a1-47ec-8690-0ace2616a171                True   Accepted Accepted
2021-10-10T07:49:47.172 [Information] OUTPUT:
2021-10-10T07:49:47.220 [Information] Executed 'Functions.StartVMs' (Succeeded, Id=edc34ae7-90ad-4c14-8f3a-b960aef7671a, Duration=31220ms)
```

- 仮想マシンが起動していることを確認

![alt text](./images/03-functions-test-function-3.png)

- タグ `ENV: PROD` を付与した仮想マシンは起動していないことを確認

![alt text](./images/03-functions-test-function-4.png)