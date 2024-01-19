(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0|(-?(((0|[1-9]\d*)\.\d+)|([1-9]\d*))))$
(assert (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; Stealthwww\x2Emyarmory\x2Ecomresultsmaster\x2Ecom
(assert (not (str.in_re X (str.to_re "Stealthwww.myarmory.comresultsmaster.com\u{13}\u{0a}"))))
; /filename=[^\n]*\u{2e}xls/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xls/i\u{0a}")))))
; ^[a-zA-Z]{1}[-][0-9]{7}[-][a-zA-Z]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; www\x2Eserverlogic3\x2Ecom\d+ToolBar.*Host\x3AHWAEUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "www.serverlogic3.com") (re.+ (re.range "0" "9")) (str.to_re "ToolBar") (re.* re.allchar) (str.to_re "Host:HWAEUser-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
