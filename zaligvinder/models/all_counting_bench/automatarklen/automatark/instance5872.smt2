(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; name\u{2e}cnnic\u{2e}cn\scom\x2Findex\.php\?tpid=\s\x5BStatic.*\x2Fbar_pl\x2Fb\.fcgi
(assert (not (str.in_re X (re.++ (str.to_re "name.cnnic.cn") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "com/index.php?tpid=") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "[Static") (re.* re.allchar) (str.to_re "/bar_pl/b.fcgi\u{0a}")))))
; /\.php\?b=[A-F0-9]+&v=1\./U
(assert (str.in_re X (re.++ (str.to_re "/.php?b=") (re.+ (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "&v=1./U\u{0a}"))))
; (([\w|\.]*)\s*={1}\s*(.*?))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.union (str.to_re "|") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (str.to_re "=")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar)))))
; \x2Frss\d+Host\u{3a}TCP\x2FAD\x2FULOGNetBusCookie\u{3a}
(assert (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "Host:TCP/AD/ULOGNetBusCookie:\u{0a}"))))
; /filename=[^\n]*\u{2e}oga/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".oga/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
