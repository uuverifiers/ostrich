(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /GET\s\/[\w-]{64}\sHTTP\/1\.[^\u{2f}]+Host\u{3a}\u{20}[^\u{3a}]+\u{3a}\d+\u{0d}\u{0a}/
(assert (str.in_re X (re.++ (str.to_re "/GET") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/") ((_ re.loop 64 64) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "HTTP/1.") (re.+ (re.comp (str.to_re "/"))) (str.to_re "Host: ") (re.+ (re.comp (str.to_re ":"))) (str.to_re ":") (re.+ (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/\u{0a}"))))
(check-sat)
