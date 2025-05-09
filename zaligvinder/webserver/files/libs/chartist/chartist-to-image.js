( function (root, factory) {
    if (typeof define === "function" && define.amd) {
        // AMD. Register as an anonymous module unless amdModuleId is set
        define("chartist2image", [], function () {
            return (root["chartist2image"] = factory());
        });
    } else if (typeof module === "object" && module.exports) {
        // Node. Does not work with strict CommonJS, but
        // only CommonJS-like environments that support module.exports,
        // like Node.
        module.exports = factory();
    } else {
        root["chartist2image"] = factory();
    }
}
(this, function () {


    var domtoimage = require('dom-to-image');
    var chartist2image = {
        vaersion: "0.0.1"
    };

    chartist2image.toJpeg = function (divId, options, Chartist) {
        return new Promise(function (resolve, reject) {
            if (options.log === true){
            console.log(Chartist);
            }
            if (options.log === true) {
                console.log(typeof Chartist === 'undefined');
            }
            if (typeof Chartist !== 'undefined') {
                Chartist.supportsForeignObject = false;
            }


            domtoimage.toJpeg(document.getElementById(divId), {
                quality: options.outputImage.quality || 1,
                bgcolor: options.outputImage.bgcolor || "#ffffff",
            })
                .then(function (dataUrl) {
                        var img = new Image();
                        img.src = dataUrl;
                        if (options.download === true) {
                            var link = document.createElement("a");
                            link.download = options.outputImage.name || 'Chart Image' + "." + options.format;
                            link.href = dataUrl;
                            link.click();
                        }
                        if (options.log === true)
                            console.log('chartist-to-image :', {title: options.outputImage.name || 'chartimage', content: img.src});

                        resolve({title: options.outputImage.name || 'cahrtimage', format: 'base64', content: img.src});
                    },
                    function (error) {

                        console.error("Error occurred while rendering the Graph >>>>", error);
                        reject(error);
                    });
        });

        /*domtoimage.toJpeg(document.getElementById(divId), {quality: options.outputImage.quality, bgcolor: options.outputImage.bgcolor})
          .then(function (dataUrl) {
              var img = new Image();
              img.src = dataUrl;
              if(options.download === true) {
              var link = document.createElement("a");
              link.download = options.outputImage.name + ".jpeg";
              link.href = dataUrl;
              link.click();
              }
              console.log({title: divId, content: img.src});

              return {title: divId, content: img.src};


            },
            function (error) {

              console.log("Error occurred while rendering the Graph >>>>", error);
            });*/
    };

    return chartist2image;

}));
