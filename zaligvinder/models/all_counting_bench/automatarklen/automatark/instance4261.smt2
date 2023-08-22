(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^Subject\x3A[^\r\n]*Trojaner-Info\sNewsletter/smi
(assert (str.in_re X (re.++ (str.to_re "/Subject:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "Trojaner-Info") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Newsletter/smi\u{0a}"))))
; ^(http(s?)\:\/\/)*[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&%\$#_]*)?$
(assert (not (str.in_re X (re.++ (re.* (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://"))) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")) (re.* (re.++ (re.* (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")))) (re.* (re.++ (str.to_re ":") (re.* (str.to_re "0-9")))) (re.opt (str.to_re "/")) (re.opt (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "_")))) (str.to_re "\u{0a}")))))
; ^(\(?[0-9]{3}[\)-\.]?\ ?)?[0-9]{3}[-\.]?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.range ")" ".")) (re.opt (str.to_re " ")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\-?[0-9]{1,3}(\,[0-9]{3})*(\.[0-9]+)?$|^[0-9]+(\.[0-9]+)?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))))
; Computer\x7D\x7BSysuptime\x3Awww\x2Eezula\x2EcomanswerServerHost\x3Aserveradfsgecoiwnf
(assert (not (str.in_re X (str.to_re "Computer}{Sysuptime:www.ezula.comanswerServerHost:serveradfsgecoiwnf\u{1b}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
