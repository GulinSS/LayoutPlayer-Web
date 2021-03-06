// Generated by CoffeeScript 1.4.0
'use strict';

describe("Тесты ViewModel'ей списка проектов.", function() {
  describe("Project:", function() {
    it("Параметрами конструктора являются: список проектов и объект, поля которого совмещаются с экземпляром проекта", function() {});
    it("Метод удаления, как это ни странно, удаляет проект из переданной в конструктор коллекции", function() {});
    describe("При изменении объекта методом update", function() {
      it("результатом является deferred-объект", function() {});
      it("выполняется запрос на сервер для передачи коллекции файлов-изображений и нового имени проекта", function() {});
      return it("объект проекта изменяет свое имя на новое, изменяется изображение на возвращенное от сервера", function() {});
    });
    return describe("При переключении объекта в режим редактирования", function() {
      it("в списке проектов на место проекта встает ProjectEdited", function() {});
      return it("полученный ProjectEdited имеет имя и картинку от проекта", function() {});
    });
  });
  return describe("ProjectEdited:", function() {
    return it("");
  });
});
