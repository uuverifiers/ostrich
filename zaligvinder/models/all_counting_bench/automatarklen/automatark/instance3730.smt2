(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]{1}[0-9]{0,7})+((,[1-9]{1}[0-9]{0,7}){0,1})+$
(assert (not (str.in_re X (re.++ (re.+ (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 7) (re.range "0" "9")))) (re.+ (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 7) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; /\d+&/miR
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "&/miR\u{0a}")))))
; TM_SEARCH3Host\u{3a}User-Agent\x3Amedia\x2Edxcdirect\x2Ecom
(assert (not (str.in_re X (str.to_re "TM_SEARCH3Host:User-Agent:media.dxcdirect.com\u{0a}"))))
; url=\"([^\[\]\"]*)\"
(assert (str.in_re X (re.++ (str.to_re "url=\u{22}") (re.* (re.union (str.to_re "[") (str.to_re "]") (str.to_re "\u{22}"))) (str.to_re "\u{22}\u{0a}"))))
; \x2Fsearchfast\x2FNavhelper
(assert (not (str.in_re X (str.to_re "/searchfast/Navhelper\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
