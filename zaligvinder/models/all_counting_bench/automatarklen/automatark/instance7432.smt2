(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Download\d+ocllceclbhs\u{2f}gth
(assert (str.in_re X (re.++ (str.to_re "Download") (re.+ (re.range "0" "9")) (str.to_re "ocllceclbhs/gth\u{0a}"))))
; search\.dropspam\.com.*SupportFiles.*Referer\x3A
(assert (str.in_re X (re.++ (str.to_re "search.dropspam.com") (re.* re.allchar) (str.to_re "SupportFiles\u{13}") (re.* re.allchar) (str.to_re "Referer:\u{0a}"))))
; (^\-|\+)?([1-9]{1}[0-9]{0,2}(\,\d{3})*|[1-9]{1}\d{0,})$|^0?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9"))))) (re.++ (re.opt (str.to_re "0")) (str.to_re "\u{0a}"))))))
; [a-zA-Z][a-zA-Z0-9_\-\,\.]{5,31}
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 5 31) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ",") (str.to_re "."))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
