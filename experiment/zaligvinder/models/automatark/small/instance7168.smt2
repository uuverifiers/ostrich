(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d)+\<\/a\>
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "</a>\u{0a}"))))
; ^0?.[0]{1,2}[1-9]{1}$|^0?.[1-9]{1}?\d{0,2}$|^(1|1.{1}[0]{1,3})$|^0?.[0]{1}[1-9]{1}\d{1}$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "0")) re.allchar ((_ re.loop 1 2) (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (re.opt (str.to_re "0")) re.allchar ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "1") ((_ re.loop 1 1) re.allchar) ((_ re.loop 1 3) (str.to_re "0"))) (re.++ (re.opt (str.to_re "0")) re.allchar ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}zip/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".zip/i\u{0a}")))))
; IP\d+horoscopefowclxccdxn\u{2f}uxwn\.ddy
(assert (not (str.in_re X (re.++ (str.to_re "IP") (re.+ (re.range "0" "9")) (str.to_re "horoscopefowclxccdxn/uxwn.ddy\u{0a}")))))
(check-sat)
