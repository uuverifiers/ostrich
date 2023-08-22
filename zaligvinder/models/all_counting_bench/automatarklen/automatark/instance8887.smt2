(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^sleep\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/sleep|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; LOGGuardedHost\x3Awww\x2Esearchreslt\x2Ecomwp-includes\x2Ffeed\x2Ephp\x3F
(assert (not (str.in_re X (str.to_re "LOGGuardedHost:www.searchreslt.comwp-includes/feed.php?\u{0a}"))))
; /filename\s*=\s*[^\r\n]*?\u{2e}mcl[\u{22}\u{27}\u{3b}\s\r\n]/i
(assert (str.in_re X (re.++ (str.to_re "/filename") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ".mcl") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ";") (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/i\u{0a}"))))
; %[\-\+0\s\#]{0,1}(\d+){0,1}(\.\d+){0,1}[hlI]{0,1}[cCdiouxXeEfgGnpsS]{1}
(assert (not (str.in_re X (re.++ (str.to_re "%") (re.opt (re.union (str.to_re "-") (str.to_re "+") (str.to_re "0") (str.to_re "#") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (re.opt (re.union (str.to_re "h") (str.to_re "l") (str.to_re "I"))) ((_ re.loop 1 1) (re.union (str.to_re "c") (str.to_re "C") (str.to_re "d") (str.to_re "i") (str.to_re "o") (str.to_re "u") (str.to_re "x") (str.to_re "X") (str.to_re "e") (str.to_re "E") (str.to_re "f") (str.to_re "g") (str.to_re "G") (str.to_re "n") (str.to_re "p") (str.to_re "s") (str.to_re "S"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
