(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; logs\s+TCP.*Toolbarads\.grokads\.com
(assert (not (str.in_re X (re.++ (str.to_re "logs") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TCP") (re.* re.allchar) (str.to_re "Toolbarads.grokads.com\u{0a}")))))
; A-311Host\x3Alnzzlnbk\u{2f}pkrm\.finSubject\u{3a}
(assert (not (str.in_re X (str.to_re "A-311Host:lnzzlnbk/pkrm.finSubject:\u{0a}"))))
; \.bmp[^\n\r]*couponbar\.coupons\.com.*Host\x3AHost\u{3a}HTTPwww
(assert (not (str.in_re X (re.++ (str.to_re ".bmp") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "couponbar.coupons.com") (re.* re.allchar) (str.to_re "Host:Host:HTTPwww\u{0a}")))))
; ^(ftp|https?):\/\/([^:]+:[^@]*@)?([a-zA-Z0-9][-_a-zA-Z0-9]*\.)*([a-zA-Z0-9][-_a-zA-Z0-9]*){1}(:[0-9]+)?\/?(((\/|\[|\]|-|~|_|\.|:|[a-zA-Z0-9]|%[0-9a-fA-F]{2})*)\?((\/|\[|\]|-|~|_|\.|,|:|=||\{|\}|[a-zA-Z0-9]|%[0-9a-fA-F]{2})*\&?)*)?(#([-_.a-zA-Z0-9]|%[a-fA-F0-9]{2})*)?$
(assert (str.in_re X (re.++ (re.union (str.to_re "ftp") (re.++ (str.to_re "http") (re.opt (str.to_re "s")))) (str.to_re "://") (re.opt (re.++ (re.+ (re.comp (str.to_re ":"))) (str.to_re ":") (re.* (re.comp (str.to_re "@"))) (str.to_re "@"))) (re.* (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re "_") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "."))) ((_ re.loop 1 1) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re "_") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (str.to_re "/")) (re.opt (re.++ (re.* (re.union (str.to_re "/") (str.to_re "[") (str.to_re "]") (str.to_re "-") (str.to_re "~") (str.to_re "_") (str.to_re ".") (str.to_re ":") (re.++ (str.to_re "%") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")))) (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "?") (re.* (re.++ (re.* (re.union (str.to_re "/") (str.to_re "[") (str.to_re "]") (str.to_re "-") (str.to_re "~") (str.to_re "_") (str.to_re ".") (str.to_re ",") (str.to_re ":") (str.to_re "=") (str.to_re "{") (str.to_re "}") (re.++ (str.to_re "%") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")))) (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.opt (str.to_re "&")))))) (re.opt (re.++ (str.to_re "#") (re.* (re.union (re.++ (str.to_re "%") ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9")))) (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(check-sat)