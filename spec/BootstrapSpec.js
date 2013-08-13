describe("bootstrap detection", function () {
    it("knows bootstrap.css isn't loaded", function () {
        expect(bootstrap.weHaveBootstrap()).toBeFalsy();
    });

    it("should be able to load bootstrap", function () {
        var initialStylesheets = document.getElementsByTagName("link").length;
        bootstrap.getBootstrap();
        expect(document.getElementsByTagName("link").length).toBe(initialStylesheets + 1);
    });
});

describe("bootstrap input creation", function () {
    it("should be able to create an input", function () {
        var input = bootstrap.input();
        expect($(input)).toBe('input');
    });


    it("should have form control class", function () {
        var input = bootstrap.input();
        expect($(input)).toBe('.form-control');
    });

    it("should be of type text", function () {
        var input = bootstrap.input();
        expect($(input)).toBe('[type=text]');
    });
});

describe("bootstrap row creation", function(){
    var row = bootstrap.row();

    it("should create a div", function(){
        expect(row.tagName.toLowerCase()).toBe("div");
    });

    it("should have the row class", function(){
        expect(row.className).toBe("row");
    });
});

describe("bootstrap list creation", function () {
    it("should be able to create a list", function () {
        var list = bootstrap.list();
        expect($(list)).toBe('ul');
    });

    it("should be able to create an empty list", function () {
        var list = bootstrap.list();
        expect($(list)).toBeEmpty();
    });

    it("should have li children", function () {
        var list = bootstrap.list(["example"]);
        expect($(list.children[0])).toBe('li');
    });

    it("li should have input children when a callback is present", function () {
        var list = bootstrap.list(["example"], function(){});
        expect($(list.children[0].children[0])).toBe('input');
    });


    it("li should not have input children when a callback is absent", function () {
        var list = bootstrap.list(["example"]);
        expect(list.children[0].children.length).toBe(0);
    });

    it("li should have text for each array item", function () {
        var list = bootstrap.list(["foo", "bar", "baz"]);
        expect(list.children[0].textContent).toBe("foo");
        expect(list.children[1].textContent).toBe("bar");
        expect(list.children[2].textContent).toBe("baz");

    });

    it("li should have inputs with a value for each array item (with callback)", function () {
        var list = bootstrap.list(["foo", "bar", "baz"], function(){});
        expect(list.children[0].children[0].value).toBe("foo");
        expect(list.children[1].children[0].value).toBe("bar");
        expect(list.children[2].children[0].value).toBe("baz");
    });
});
