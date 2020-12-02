;'use strict';
;module.exports = function (str, sep) {
    ;if (typeof str !== 'string') {
        ;throw new TypeError('Expected a string');
    ;}

    ;sep = typeof sep === 'undefined' ? '_' : sep;

    ;return str
        ;.replace(/([a-z\d])([A-Z])/g, '$1' + sep + '$2')
        ;.replace(/([A-Z]+)([A-Z][a-z\d]+)/g, '$1' + sep + '$2')
        ;.toLowerCase();
;};

(set-logic QF_S)

(declare-const s String)
(declare-const in1 String)
(declare-const res String)

; we assume 'sep' is '-'
(assert (= in1 (str.replace_cg_all
               s
               (re.++
                 ((_ re.capture 1) (re.union
                                     (re.range "a" "z")
                                     (re.range "0" "9")))
                 ((_ re.capture 2) (re.range "A" "Z")))
               (re.++ (_ re.reference 1) (str.to.re "-") (_ re.reference 2)))))

(assert (= res
           (str.replace_cg_all
             in1
             (re.++
               ((_ re.capture 1) (re.+ (re.range "A" "Z")))
               ((_ re.capture 2) (re.++
                                   (re.range "A" "Z")
                                   (re.+ (re.union
                                           (re.range "a" "z")
                                           (re.range "0" "9")
                                           )))))
             (re.++ (_ re.reference 1) (str.to.re "-") (_ re.reference 2)))))

; we omit the 'tolowercase' part here

(assert (str.in.re s (str.to.re "CaWOGo")))

(assert (str.in.re res (str.to.re "Ca-WO-Go")))

(check-sat)
(get-model)
