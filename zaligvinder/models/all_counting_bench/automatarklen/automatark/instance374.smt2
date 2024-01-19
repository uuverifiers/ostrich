(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 3Awww\u{2e}urlblaze\u{2e}netulmxct\u{2f}mqoycEFErrorHost\x3Ae2give\.com
(assert (not (str.in_re X (str.to_re "3Awww.urlblaze.netulmxct/mqoycEFErrorHost:e2give.com\u{0a}"))))
; /^UPDATE\|[0-9]\.[0-9]\.[0-9]\|[A-F0-9]{48}\|{3}$/
(assert (str.in_re X (re.++ (str.to_re "/UPDATE|") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re "|") ((_ re.loop 48 48) (re.union (re.range "A" "F") (re.range "0" "9"))) ((_ re.loop 3 3) (str.to_re "|")) (str.to_re "/\u{0a}"))))
; ^(\d{2}-\d{2})*$
(assert (not (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
