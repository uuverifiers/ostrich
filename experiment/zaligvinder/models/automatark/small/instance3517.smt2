(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Cookie\x3A\x2Fimages\x2Fnocache\x2Ftr\x2Fgca\x2Fm\.gif\?
(assert (str.in_re X (str.to_re "Cookie:/images/nocache/tr/gca/m.gif?\u{0a}")))
; [0][^0]|([^0]{1}(.){1})|[^0]*
(assert (str.in_re X (re.union (re.++ (str.to_re "0") (re.comp (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.comp (str.to_re "0"))) ((_ re.loop 1 1) re.allchar)) (re.++ (re.* (re.comp (str.to_re "0"))) (str.to_re "\u{0a}")))))
; Host\x3A\s+www\.iggsey\.comcs\x2Esmartshopper\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.iggsey.comcs.smartshopper.com\u{0a}")))))
(check-sat)
