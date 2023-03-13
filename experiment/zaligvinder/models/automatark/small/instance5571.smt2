(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?[0-9]\d{0,2}(\.\d{1,2})?%?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.range "0" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; Host\x3A\s+Boss\s+media\x2Etop-banners\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Boss") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.top-banners.com\u{0a}")))))
; (\{\\f\d*)\\([^;]+;)
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}\u{0a}{\u{5c}f") (re.* (re.range "0" "9")) (re.+ (re.comp (str.to_re ";"))) (str.to_re ";")))))
; ^(\[a-zA-Z '\]+)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}[a-zA-Z '") (re.+ (str.to_re "]"))))))
; /\.php\?catalogp\=\d{2}$/U
(assert (str.in_re X (re.++ (str.to_re "/.php?catalogp=") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(check-sat)
