'use strict';

var importSettings = (function () {
  var emailTemplate;
  var serverTemplate;
  var projects;
  var servers = [];
  var emails = [];
  var emailsContainer;
  var serversContainer;

  function initServers(serversInit) {
    initFieldSets(serversInit, serversContainer, newServer);  
    servers = serversInit;
  }

  function initEmails(emailsInit) {
    initFieldSets(emailsInit, emailsContainer, newEmail);  
    emails = emailsInit;
  }

  function initFieldSets(data, container, newFieldSet) {
    container.html('');
    data.map(function (object) {
      var fieldSet = newFieldSet();
      setData(fieldSet, object);
      container.append(fieldSet);
    });
  }

  function setData(container, data) {
    container.find('input, select').each(function () {
      var input = $(this);
      var label = input.prev('label');
      var id = input.attr('id') + '_' + data.id; 

      if (label.length) {
        label.attr('for', id);
      }

      input.attr('id', id);
    });

    $.each(data, function(field, value) {
      var el = container.find('#' + field + '_' + data.id);
      var type = el.attr('type');
      if (type  == 'checkbox' && value) {
        el.attr('checked', 'checked');
      } else if (type == 'checkbox') {
        //
      } else {
        el.val(value);
      }
    });
  
    container.data().id = data.id;
  }

  function projectsList() {
    if (projectsList.list !== undefined) {
      return projectsList.list;
    }

    projectsList.list = '';
    projects.map(function(project) {
      projectsList.list += '<option value="' + project.id + '">'
        + project.name + '</option>';
    }) 

    return projectsList.list;
  }

  function trackersList(project) {
    if (!project.trackers.length) {
      return ''
    }

    if (trackersList[project.id] !== undefined) {
      return trackersList[project.id];
    }

    trackersList[project.id] = '';
    project.trackers.map(function(tracker) {
      trackersList[project.id] += '<option value="' + tracker.id + '">'
        + tracker.name + '</option>';
    });

    return trackersList[project.id];
  }

  function categoriesList(project) {
    if (!project.categories.length) {
      return ''
    }

    if (categoriesList[project.id] !== undefined) {
      return categoriesList[project.id];
    }

    categoriesList[project.id] = '<option value="0"></option>';
    project.categories.map(function(el) {
      categoriesList[project.id] += '<option value="' + el.id + '">'
        + el.name + '</option>';
    }); 

    return categoriesList[project.id];
  }

  function newEmail() {
    var email = $(emailTemplate);
    var serverSelect = email.find('#issues_import_server_id');

    servers.map(function(server) {
      serverSelect.append(
        '<option value="' + server.id + '">'
        + server.address + ':' + server.port 
        + '</option>'
      );
    });

    if (projects.length) {
      email.find('#project_id').append(projectsList());
      email.find('#tracker_id').append(trackersList(projects[0]));
      email.find('#issue_category_id').append(categoriesList(projects[0]));
    } 
    
    email.data().id = 0;

    return email;
  }

  function newServer() {
    var server = $(serverTemplate);
    server.data().id = 0;
    return server;
  }
  
  function saveServerRequest(fieldSet) {
    var id = fieldSet.data().id;
    var params = {server: fieldSet.serializeObject()};

    if (id === 0) {
      id = '';
    } else {
      params['_method'] = 'put';
    }

    return $.post(
      '/issues_import_servers/' + id,
      params,
      function (data) {
        if (!id && data.server.id) {
          fieldSet.data().id = data.server.id;
        }
      }
    );
  }

  function saveEmailRequest(fieldSet) {
    var id = fieldSet.data().id;
    var params = {email: fieldSet.serializeObject()};

    if (id === 0) {
      id = '';
    } else {
      params['_method'] = 'put';
    }

    return $.post(
      '/issues_import_emails/' + id,
      params,
      function (data) {
        if (!id && data.email.id) {
          fieldSet.data().id = data.email.id;
        }
      }
    );
  }

  function deleteServerRequest(fieldSet) {
    var id = fieldSet.data().id;
    return $.post(
      '/issues_import_servers/' + id,
      { _method: 'delete' }
    );
  }

  function deleteEmailRequest(fieldSet) {
    var id = fieldSet.data().id;
    return $.post(
      '/issues_import_emails/' + id,
      { _method: 'delete' }
    );
  }

  function validateServer(fieldSet) {
    return true;
  }

  function validateEmail(fieldSet) {
    return true
  }

  function isNotPersists() {
    return $(this).data().id === 0;
  }

  function bindAddFieldSet(container, getFieldSet) {
    var fieldset = container.find('fieldset').filter(isNotPersists);
    if (!fieldset.length) {
      fieldset = getFieldSet();
      container.append(fieldset);
    }
    fieldset.find('input:first').focus();
  }

  function bindDeleteFieldSet(el, container, deleteRequest, getFieldSet) {
    var fieldset = $(el).parentsUntil('fieldset').parent();
    var count = container.find('fieldset').length - 1;
    if (isNotPersists.bind(fieldset)()) {
      if (count > 0) {
        fieldset.remove();
      }
      return;
    } 
    deleteRequest(fieldset).done(function () {
      fieldset.remove();
      if (count === 0) {
        container.append(getFieldSet());
      }
    });
  }

  function bindSaveFieldSet(el, container, saveRequest, validate) {
    var fieldset = $(el).parentsUntil('fieldset').parent();
    if (!validate(fieldset)) {
      return;
    }
    saveRequest(fieldset); 
  }

  $(function() {
    emailsContainer
      .on('click', 'legend .add', function (e) {
        e.preventDefault();
        bindAddFieldSet(emailsContainer, newEmail);
      })
      .on('click', 'legend .delete', function (e) {
        e.preventDefault();
        bindDeleteFieldSet(this, emailsContainer, deleteEmailRequest, newEmail);
      })
      .on('click', 'legend .save', function (e) {
        e.preventDefault();
        bindSaveFieldSet(this, emailsContainer, saveEmailRequest, validateServer);
      });
    serversContainer
      .on('click', 'legend .add', function (e) {
        e.preventDefault();
        bindAddFieldSet(serversContainer, newServer);
      })
      .on('click', 'legend .delete', function (e) {
        e.preventDefault();
        bindDeleteFieldSet(this, serversContainer, deleteServerRequest, newServer);
      })
      .on('click', 'legend .save', function (e) {
        e.preventDefault();
        bindSaveFieldSet(this, serversContainer, saveServerRequest, validateEmail);
      });
  });

  return {
    setEmailTemplate: function(template) {
      emailTemplate = template;
      return this;
    },
    setServerTemplate: function(template) {
      serverTemplate = template;
      return this;
    },
    setProjects: function(allProjects) {
      projects = allProjects;
      return this;
    },
    init: function(emails, servers) {
      if (!emailTemplate || !serverTemplate || !projects) {
        throw "Нет неоходиммых данных";
      }

      emailsContainer = $('#emails-container');
      serversContainer = $('#servers-container');

      if (servers.length) {
        initServers(servers);
      } else {
        serversContainer.append(newServer());
      }

      if (emails.length) {
        initEmails(emails);
      } else {
        emailsContainer.append(newEmail());
      }
    }
  }
})();

(function(root, factory) {

  // AMD
  if (typeof define === "function" && define.amd) {
    define(["exports", "jquery"], function(exports, $) {
      return factory(exports, $);
    });
  }

  // CommonJS
  else if (typeof exports !== "undefined") {
    var $ = require("jquery");
    factory(exports, $);
  }

  // Browser
  else {
    factory(root, (root.jQuery || root.Zepto || root.ender || root.$));
  }

}(this, function(exports, $) {

  var patterns = {
    validate: /^[a-z_][a-z0-9_]*(?:\[(?:\d*|[a-z0-9_]+)\])*$/i,
    key:      /[a-z0-9_]+|(?=\[\])/gi,
    push:     /^$/,
    fixed:    /^\d+$/,
    named:    /^[a-z0-9_]+$/i
  };

  function FormSerializer(helper, $form) {

    // private variables
    var data     = {},
        pushes   = {};

    // private API
    function build(base, key, value) {
      base[key] = value;
      return base;
    }

    function makeObject(root, value) {

      var keys = root.match(patterns.key), k;

      // nest, nest, ..., nest
      while ((k = keys.pop()) !== undefined) {
        // foo[]
        if (patterns.push.test(k)) {
          var idx = incrementPush(root.replace(/\[\]$/, ''));
          value = build([], idx, value);
        }

        // foo[n]
        else if (patterns.fixed.test(k)) {
          value = build([], k, value);
        }

        // foo; foo[bar]
        else if (patterns.named.test(k)) {
          value = build({}, k, value);
        }
      }

      return value;
    }

    function incrementPush(key) {
      if (pushes[key] === undefined) {
        pushes[key] = 0;
      }
      return pushes[key]++;
    }

    function encode(pair) {
      switch ($('[name="' + pair.name + '"]', $form).attr("type")) {
        case "checkbox":
          return pair.value === "on" ? true : pair.value;
        default:
          return pair.value;
      }
    }

    function addPair(pair) {
      if (!patterns.validate.test(pair.name)) return this;
      var obj = makeObject(pair.name, encode(pair));
      data = helper.extend(true, data, obj);
      return this;
    }

    function addPairs(pairs) {
      if (!helper.isArray(pairs)) {
        throw new Error("formSerializer.addPairs expects an Array");
      }
      for (var i=0, len=pairs.length; i<len; i++) {
        this.addPair(pairs[i]);
      }
      return this;
    }

    function serialize() {
      return data;
    }

    function serializeJSON() {
      return JSON.stringify(serialize());
    }

    // public API
    this.addPair = addPair;
    this.addPairs = addPairs;
    this.serialize = serialize;
    this.serializeJSON = serializeJSON;
  }

  FormSerializer.patterns = patterns;

  FormSerializer.serializeObject = function serializeObject() {
    if (this.length > 1) {
      return new Error("jquery-serialize-object can only serialize one form at a time");
    }
    return new FormSerializer($, this).
      addPairs(this.serializeArray()).
      serialize();
  };

  FormSerializer.serializeJSON = function serializeJSON() {
    if (this.length > 1) {
      return new Error("jquery-serialize-object can only serialize one form at a time");
    }
    return new FormSerializer($, this).
      addPairs(this.serializeArray()).
      serializeJSON();
  };

  if (typeof $.fn !== "undefined") {
    $.fn.serializeObject = FormSerializer.serializeObject;
    $.fn.serializeJSON   = FormSerializer.serializeJSON;
  }

  exports.FormSerializer = FormSerializer;

  return FormSerializer;
}));
