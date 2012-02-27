// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
        LowPro.optimize$$ = false;

        jQuery(function() {
          jQuery( ".selector" ).datepicker({ defaultDate: null });
          jQuery('#Date').datepicker({
            },
            jQuery.datepicker.regional['es']
          );
        });
   //     new Ajax.PeriodicalUpdater('dashboard', '/ord_trabs/tablerojax',
   //
   //         method: 'get',
   //         frequency:3
   //       });
   //     new Ajax.PeriodicalUpdater('fronte', '/',
   //       {
   //         method: 'get',
   //         frequency:5
   //       });
        Event.addBehavior({
            "form.ord-trab select.ord_trab_cliente:change": function(ev) {
                Hobo.ajaxRequest(window.location.href, ['primter'],
                    {params: Form.serializeElements([this]), method: 'get',
                    spinnerNextTo: this, message: ""});
            },
            "form.ord-trab select.ord_trab_impresora:change": function(ev) {
                Hobo.ajaxRequest(window.location.href, ['cyl'],
                    {params: Form.serializeElements([this]), method: 'get',
                    spinnerNextTo: this, message: ""});
            },
            "form.ord-trab select.ord_trab_cilindro:change": function(ev) {
                Hobo.ajaxRequest(window.location.href, ['distor'],
                    {params: Form.serializeElements([this]), method: 'get',
                    spinnerNextTo: this, message: ""});
                Hobo.ajaxRequest(window.location.href, ['pctdistor'],
                    {params: Form.serializeElements([this]), method: 'get',
                    spinnerNextTo: this, message: ""});
            

  //          },
 //           "form.existencia select.tipo-tag existencia-tipo:change": function(ev) {
 //              Hobo.ajaxRequest(window.location.href, ['bodega'],
    //                {params: Form.serializeElements([this]), method: 'get',
  //                  spinnerNextTo: this, message: ""});

            }
        });

        //Scriptaculous: $('primter');

