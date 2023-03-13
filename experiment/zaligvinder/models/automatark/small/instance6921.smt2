(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; DesktopSupportFiles\x2EhtmlReferer\x3Awww\x2Efreescratchandwin\x2Ecom
(assert (str.in_re X (str.to_re "DesktopSupportFiles\u{13}.htmlReferer:www.freescratchandwin.com\u{0a}")))
; ^[A-Z]{1,3}\d{6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "A" "Z")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
