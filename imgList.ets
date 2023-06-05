import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import data_preferences from '@ohos.data.preferences';
import featureAbility from '@ohos.ability.featureAbility';
@Entry
@Component
struct Home {
  @State message: string = '保存的图片'
  @State img_link: Array<string> = router.getParams()['img']
  @State img_tag: Array<string>  = router.getParams()['tag']
  @State img: Array<any> = []

  aboutToAppear(){
    console.info(this.img_link.length.toString())
    console.info(this.img_tag.length.toString())
    let cnt = 0
    this.img_tag.forEach(item => {
      console.info(this.img_link[cnt])
      console.info(this.img_tag[cnt])
      this.img.push({'tag':this.img_tag[cnt],'url':this.img_link[cnt]})
      cnt++
    });

  }
  aboutToDisappear(){
    this.img = []
  }
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .textAlign(TextAlign.Center)
          .fontColor(Color.Gray)
        List({ space: 20, initialIndex: 0 }){
          ListItem(){
            Row(){
              Text('随机生成风景画')
                .fontColor(Color.Green)
                .fontSize(20)
                .textAlign(TextAlign.Center)
                .width("70%")
              Button('进入')
                .onClick(()=>{router.pushUrl({url:'pages/index'})})
                .fontColor(Color.Red)
            }
          }
          ForEach(this.img,(item) => {
            ListItem(){
              Row(){
                Text(item.tag)
                  .fontColor(Color.Green)
                  .fontSize(20)
                  .textAlign(TextAlign.Center)
                  .width("50%")
                  .maxLines(3)
                Image(item.url)
                  .height(90)
                  .width(50)
                Button('删除这个')
                  .onClick(()=>{promptAction.showToast({message:"敬请期待",duration:2000})})
                  .fontColor(Color.Red)
              }
            }
          },item => item.url)
          ListItem(){
            Row(){
              Text('删除所有')
                .fontColor(Color.Green)
                .fontSize(20)
                .textAlign(TextAlign.Center)
                .width("70%")
              Button('删除')
                .onClick(()=>{
                  promptAction.showToast({message:"删除完成",duration:2000})
                  let context = featureAbility.getContext();
                  data_preferences.deletePreferences(context, 'mystore', function (err, val) {
                    if (err) {
                      console.info("Failed to delete preferences. code =" + err.code + ", message =" + err.message);
                      return;
                    }
                    console.info("Succeeded in deleting preferences." );
                  })
                  this.img = []
                })
                .fontColor(Color.Red)
            }
          }
        }
        .width('90%')
        .height('90%')
        .scrollBar(BarState.On)
      }
      .width('100%')
    }
    .height('100%')
  }
}