(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/b\/(letr|req|opt|eve)\/[0-9a-fA-F]{24}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//b/") (re.union (str.to_re "letr") (str.to_re "req") (str.to_re "opt") (str.to_re "eve")) (str.to_re "/") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "/U\u{0a}")))))
; /GET\s\/[\w-]{64}\sHTTP\/1\.[^\u{2f}]+Host\u{3a}\u{20}[^\u{3a}]+\u{3a}\d+\u{0d}\u{0a}/
(assert (str.in_re X (re.++ (str.to_re "/GET") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/") ((_ re.loop 64 64) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "HTTP/1.") (re.+ (re.comp (str.to_re "/"))) (str.to_re "Host: ") (re.+ (re.comp (str.to_re ":"))) (str.to_re ":") (re.+ (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/\u{0a}"))))
; /bbdd(host|user|passwd)=\u{22}[^\s]*?([\u{60}\u{3b}\u{7c}]|\u{24}\u{28})/i
(assert (not (str.in_re X (re.++ (str.to_re "/bbdd") (re.union (str.to_re "host") (str.to_re "user") (str.to_re "passwd")) (str.to_re "=\u{22}") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "$(") (str.to_re "`") (str.to_re ";") (str.to_re "|")) (str.to_re "/i\u{0a}")))))
(check-sat)
