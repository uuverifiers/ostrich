(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(b|B)(f|F)(p|P)(o|O)(\s|\sC/O\s)[0-9]{1,4}
(assert (not (str.in_re X (re.++ (re.union (str.to_re "b") (str.to_re "B")) (re.union (str.to_re "f") (str.to_re "F")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "o") (str.to_re "O")) ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "C/O") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
; /^\u{2f}[A-Za-z0-9]{33}\?s=\d\&m=\d$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 33 33) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "?s=") (re.range "0" "9") (str.to_re "&m=") (re.range "0" "9") (str.to_re "/U\u{0a}"))))
; <font[a-zA-Z0-9_\^\$\.\|\{\[\}\]\(\)\*\+\?\\~`!@#%&-=;:'",/\n\s]*>
(assert (not (str.in_re X (re.++ (str.to_re "<font") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "^") (str.to_re "$") (str.to_re ".") (str.to_re "|") (str.to_re "{") (str.to_re "[") (str.to_re "}") (str.to_re "]") (str.to_re "(") (str.to_re ")") (str.to_re "*") (str.to_re "+") (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "~") (str.to_re "`") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "%") (re.range "&" "=") (str.to_re ";") (str.to_re ":") (str.to_re "'") (str.to_re "\u{22}") (str.to_re ",") (str.to_re "/") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ">\u{0a}")))))
(check-sat)
