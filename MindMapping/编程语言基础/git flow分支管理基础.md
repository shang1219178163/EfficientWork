* 两种核心分支

```
    1.主分支(Master)：代码库应该有且仅有一个主分支。所有提供给用户使用的正式版本，都在这个主分支上发布。这个分支只能从其它分支合并，不能在这个分支上直接修改。需要注意的是，所有在master上的提交应该标记tag。
    2.开发主分支(Develop)：这个分支是我们是我们的主开发分支，包含所有要发布到下一个Release的代码，这个主要合并与其他分支，比如Feature分支。该分支应该只是进行一些优化和升级开发，如果有新的需求应该拉出一个feature分支。
```    
* 三种临时分支

```
    1.功能分支(feature)：这个分支主要是用来开发一个新的功能，一旦开发完成，我们合并回Develop分支进入下一个Release。
    2.预发布分支(release)：当你需要发布一个新Release的时候，我们基于Develop分支创建一个Release分支，完成Release后，我们合并到Master和Develop分支。
    3.修补bug分支(hotfix)：当我们在Production发现新的Bug时候，我们需要创建一个Hotfix, 完成Hotfix后，我们合并回Master和Develop分支，所以Hotfix的改动会进入下一个Release。
    这三种分支都属于临时性需要，使用完以后，应该删除，使得代码库的常设分支始终只有master和develop。

```
* 分支命名规范

```
    1.feature分支：以'feature_'开头，如feature_v1.1
    2.release分支：以'release_'开头，如release_v1.1
    3.hotfix分支：以'hotfix_'开头，如hotfix_20160112
    备注：
    tag标记：如果是release分支合并，则以'release_'开头。如果是hotfix分支合并，则以'hotfix_'开头。
    master分支每次提交都要打tag，release tag：如release_v1.1，hotfix tag：如hotfix_20160112
    命名都统一采用小写。
```
* 总结

```
    1.一定要按git flow的流程去管理分支，如feature分支开发完要合并到develop，如果要发布版本到test环境，则从develop拉出一个release分支，release完成后要合并回master和develop分支，修复生产环境问题需要从master拉出一个hotfix分支，hotfix完成后要合并回master和develop分支，并且在master打上tag。
    2.一定要按分支命名规范来命名，便于管理和维护。
    3.了解了git flow工作流程后，可以不使用git flow GUI工具，手动操作即可，可以是原生git命令+vs配合操作，比如给master打tag就要用git命令，这在vs里操作不了的，比如合并分支，虽然也可以使用git命令实现，但在vs里操作更方便直观。
    4.一定要保持分支的纯净，不要随便污染分支。比如，develop分支只包含要发布到下一个release的代码，在没有拉出release分支前不要合并新的feature分支进来。release分支基于develop分支创建，拉出release分支后，我们可以在这个release分支上测试和修复bug，但是，一旦打了release分支后不要从develop分支合并新的改动过来。develop拉出release分支的同时，也意味着develop分支可以开始下一个release的准备工作了。

```