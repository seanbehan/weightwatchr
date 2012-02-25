(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  $(function() {
    var App, Entries;
    window.Entry = (function(_super) {

      __extends(Entry, _super);

      function Entry() {
        Entry.__super__.constructor.apply(this, arguments);
      }

      Entry.configure('Entry', 'weight');

      Entry.extend(Spine.Model.Local);

      Entry.weights = function() {
        return Entry.all().map(function(entry) {
          return entry.weight;
        });
      };

      Entry.currentWeight = function() {
        return parseInt(Entry.all()[Entry.all().length - 1].weight);
      };

      Entry.targetWeights = function() {
        return Entry.all().map(function(entry) {
          return 184 - parseInt(entry.weight);
        });
      };

      Entry.ratings = function() {
        return Entry.all().map(function(entry) {
          return entry.rating;
        });
      };

      return Entry;

    })(Spine.Model);
    Entries = (function(_super) {

      __extends(Entries, _super);

      Entries.prototype.events = {
        "click .delete": "delete"
      };

      function Entries() {
        this.render = __bind(this.render, this);        Entries.__super__.constructor.apply(this, arguments);
        this.entry.bind('update', this.render);
        this.entry.bind("destroy", this.release);
      }

      Entries.prototype.render = function() {
        this.replace($("#template").tmpl(this.entry));
        return this;
      };

      Entries.prototype["delete"] = function() {
        return this.entry.destroy();
      };

      return Entries;

    })(Spine.Controller);
    App = (function(_super) {

      __extends(App, _super);

      App.prototype.events = {
        'keyup input[name=weight]': 'create',
        'click input[name=weight]': 'initInput',
        'blur input[name=weight]': 'initInput'
      };

      App.prototype.elements = {
        ".entries": "entries",
        "input[name=weight]": "input",
        ".sparklines": "sparkline",
        ".barchart": "barchart",
        "#currentWeight": "currentWeight",
        "#donut": "donut"
      };

      function App() {
        this.updateCurrentWeight = __bind(this.updateCurrentWeight, this);
        this.drawSparkLine = __bind(this.drawSparkLine, this);
        this.addOne = __bind(this.addOne, this);
        this.addAll = __bind(this.addAll, this);        App.__super__.constructor.apply(this, arguments);
        Entry.bind("refresh", this.addAll);
        Entry.bind("create", this.addOne);
        Entry.bind("refresh change", this.drawSparkLine);
        Entry.bind("refresh change", this.updateCurrentWeight);
        Entry.fetch();
      }

      App.prototype.create = function(event) {
        event.preventDefault();
        if (event.keyCode === 13) {
          new Entry({
            weight: this.input.val()
          }).save();
          return this.input.val('');
        }
      };

      App.prototype.initInput = function() {
        if (this.input.val() === "Enter weight:") {
          return this.input.val('');
        } else {
          return this.input.val('Enter weight:');
        }
      };

      App.prototype.addAll = function() {
        return Entry.each(this.addOne);
      };

      App.prototype.addOne = function(entry) {
        return this.entries.prepend(new Entries({
          entry: entry
        }).render().el);
      };

      App.prototype.drawSparkLine = function() {
        return this.sparkline.sparkline(Entry.weights());
      };

      App.prototype.updateCurrentWeight = function() {
        this.currentWeight.html(Entry.currentWeight());
        return this.donut.css({
          width: Entry.currentWeight() - 50
        });
      };

      return App;

    })(Spine.Controller);
    return new App({
      el: $("#app")
    });
  });

}).call(this);
