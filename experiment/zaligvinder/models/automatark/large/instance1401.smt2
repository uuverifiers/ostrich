(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}docm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".docm/i\u{0a}"))))
; ^([a-zA-Z0-9\-]{2,80})$
(assert (str.in_re X (re.++ ((_ re.loop 2 80) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; ^(sip|sips):.*\@((\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})|([a-zA-Z\-\.]+\.[a-zA-Z]{2,5}))(:[\d]{1,5})?([\w\-?\@?\;?\,?\=\%\&]+)?
(assert (not (str.in_re X (re.++ (str.to_re "sips:") (re.* re.allchar) (str.to_re "@") (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) re.allchar ((_ re.loop 1 3) (re.range "0" "9")) re.allchar ((_ re.loop 1 3) (re.range "0" "9")) re.allchar ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (re.opt (re.+ (re.union (str.to_re "-") (str.to_re "?") (str.to_re "@") (str.to_re ";") (str.to_re ",") (str.to_re "=") (str.to_re "%") (str.to_re "&") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "\u{0a}")))))
(check-sat)
