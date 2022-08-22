
### input
```
常规输入框textField
<input type="text" name="name" value="">
    
常规按钮UIButton
<input type="submit" name="submit" value="Order Now">
    
单选框
  <p>
    <input type="radio" name="beantype" value="whole">whole bean<br>
    <input type="radio" name="beantype" value="ground" checked>ground
  </p>
            
复选框	
<p>
    <input type="checkbox" name="Extras[]" value="one">Gift warp <br>
    <input type="checkbox" name="Extras[]" value="one" checked>Includ eatalog with Order
  </p>
  
密码键盘输入框          
<input type=“password” name=“secret”>

只允许输入数字
<input type="number" name="bags" value="1" min="1" max="100">
    
范围选择器
<input type=“range” min=“0” max=“20” step=”5”>

颜色选择器
<input type=“color”>		

日期选择器			
<input type=“date”>				

邮箱地址键盘输入框
<input type=“email”>
			
电话键盘输入框		
<input type=“tel”>
				
网址键盘输入框		
<input type=“url”>

choose file按钮
<input type=“file” name=“doc”>

通用属性
input - placeholder
input - required
```
   
### textarea
```
<textarea>		文本框/textView
<textarea name="textarea" rows="8" cols="80"></textarea>
```

### Select
```
Select	单选菜单/下拉列表(添加 mutiple变为多选菜单)   selected
<p>
    <select class="" name="beans">
        <option value="house blend">house blend</option>
        <option value="shade grown" selected>shade grown</option>
        <option value="bolivia supremo">bolivia supremo</option>
        <option value="organic guatemala">organic guatemala</option>
        <option value="kenghya">kenghya</option>
      </select>
</p>
```   
 
### fieldset

```
    
fieldset和legend 分组表单，效果类似复选框
<p>
    <fieldset>
      <legend>fieldset控件组</legend>
      <input type="checkbox" name="spice" value="salt">Salt <br>
      <input type="checkbox" name="spice" value="pepper" checked>Pepper <br>
      <input type="checkbox" name="spice" value="garlic">Garlic <br>
    </fieldset>
</p>
                
```
    

