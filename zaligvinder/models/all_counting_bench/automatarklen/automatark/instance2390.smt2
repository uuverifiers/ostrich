(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; From\x3A.*Host\x3A\s+Downloadfowclxccdxn\u{2f}uxwn\.ddy
(assert (str.in_re X (re.++ (str.to_re "From:") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Downloadfowclxccdxn/uxwn.ddy\u{0a}"))))
; ^[http|ftp|wap|https]{3,5}:\//\www\.\w*\.[com|net]{2,3}$
(assert (str.in_re X (re.++ ((_ re.loop 3 5) (re.union (str.to_re "h") (str.to_re "t") (str.to_re "p") (str.to_re "|") (str.to_re "f") (str.to_re "w") (str.to_re "a") (str.to_re "s"))) (str.to_re "://") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re "ww.") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (str.to_re "c") (str.to_re "o") (str.to_re "m") (str.to_re "|") (str.to_re "n") (str.to_re "e") (str.to_re "t"))) (str.to_re "\u{0a}"))))
; \d\d?\d?\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?
(assert (not (str.in_re X (re.++ (re.range "0" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3A\s+Basic\s+\.htaServerTheef2
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Basic") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".htaServerTheef2\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
