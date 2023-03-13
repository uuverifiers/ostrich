(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}rat([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.rat") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(([a-zA-Z]{3})?([0-9]{4}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 4 4) (re.range "0" "9"))))))
; ^[^<>`~!/@\#},.?"-$%:;)(_ ^{&*=|'+]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "<") (str.to_re ">") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "/") (str.to_re "@") (str.to_re "#") (str.to_re "}") (str.to_re ",") (str.to_re ".") (str.to_re "?") (re.range "\u{22}" "$") (str.to_re "%") (str.to_re ":") (str.to_re ";") (str.to_re ")") (str.to_re "(") (str.to_re "_") (str.to_re " ") (str.to_re "^") (str.to_re "{") (str.to_re "&") (str.to_re "*") (str.to_re "=") (str.to_re "|") (str.to_re "'") (str.to_re "+"))) (str.to_re "\u{0a}")))))
; from\s+\x2Fdss\x2Fcc\.2_0_0\.[^\n\r]*uploadServer
(assert (not (str.in_re X (re.++ (str.to_re "from") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/dss/cc.2_0_0.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "uploadServer\u{0a}")))))
(check-sat)
