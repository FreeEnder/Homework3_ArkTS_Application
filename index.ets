import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import http from '@ohos.net.http';

import data_preferences from '@ohos.data.preferences';
import featureAbility from '@ohos.ability.featureAbility';

@Entry
@Component
struct Index {
  @State message: string = '每日风景图画'
  @State img_link: string = ''
  @State img_tag: string = ''

  private img_list: Array<string> = []
  private img_tag_list: Array<string> = []
  private save: Boolean = true

  aboutToAppear() {
    http.createHttp().request(
      'https://qqlykm.cn/api/fengjing/index?key=84MhdyhPdOY66ltcJhyukusPAI&type=json',
      (err, data) => {
        if(!err) {
          let target: any = JSON.parse(data.result.toString())
          this.img_link = target.data.cover
          this.img_tag  = target.data.tag
        }})
    let context = featureAbility.getContext();
    let preferences = null;
    let promise = data_preferences.getPreferences(context, 'mystore');
    promise.then((object) => {
      preferences = object;
      preferences.get('imgList', []).then((value) => { this.img_list = this.img_list.concat(value); });
      console.info("Succeeded in getting preferences.");
    }).catch((err) => {
      console.log("url-> Failed to get preferences. code = " + err.code + ", message = " + err.message);
    })
    preferences = null;
    promise.then((object) => {
      preferences = object;
      preferences.get('tagList', []).then((value) => { this.img_tag_list = this.img_tag_list.concat(value); });
      console.info("Succeeded in getting preferences.");
    }).catch((err) => {
      console.log("tag-> Failed to get preferences. code = " + err.code + ", message = " + err.message);
    })
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(40)
          .fontColor(Color.Brown)
          .textAlign(TextAlign.Center)
        Image(this.img_link)
          .width("90%")
          .height("85%")
        Text(this.img_tag)
          .fontSize(20)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
        Row() {
          Button('保存图像')
            .onClick(() => {
              if (this.save == true){
              let context = featureAbility.getContext();
              let preferences = null;
              let promise = data_preferences.getPreferences(context, 'mystore');
              promise.then((object) => {
                preferences = object;
                this.img_list.push(this.img_link);
                this.img_tag_list.push(this.img_tag)
                preferences.put('imgList', this.img_list).then(() => {
                  preferences.flush();
                  console.info("Succeeded in putting value of 'fontColor'.->img");
                }).catch((err) => {
                  console.info("img-> Failed to put value of 'fontColor'. code = " + err.code +", message = " + err.message);
                })
                preferences.put('tagList', this.img_tag_list).then(() => {
                  preferences.flush();
                  console.info("Succeeded in putting value of 'fontColor'. ->tag");
                }).catch((err) => {
                  console.info("tag-> Failed to put value of 'fontColor'. code = " + err.code +", message = " + err.message);
                })
                console.info("Succeeded in getting preferences.");
              }).catch((err) => {
                console.log("obj-> Failed to get preferences. code = " + err.code + ", message = " + err.message);
              })
              promptAction.showToast({message:'已保存',duration:2000})
                this.save = false
            }
              else {
                promptAction.showToast({message:'已经保存过了',duration:2000})
              }
            })
          Button('返回主页')
            .onClick(() => {
              router.pushUrl({ url: 'pages/imgList' ,
                params:{img:this.img_list, tag:this.img_tag_list}},router.RouterMode.Single)
            })
          Button('重新生成')
            .fontColor(Color.Red)
            .onClick(() => {

              http.createHttp().request(
                'https://qqlykm.cn/api/fengjing/index?key=84MhdyhPdOY66ltcJhyukusPAI&type=json',
                (err, data) => {
                  if (!err) {
                    let target: any = JSON.parse(data.result.toString())
                    this.img_link = target.data.cover
                    this.img_tag = target.data.tag
                  }
                }
              )
              this.save = true
            }
            )
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}