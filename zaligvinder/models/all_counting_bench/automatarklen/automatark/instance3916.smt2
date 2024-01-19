(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; frame_ver2\s+www\u{2e}urlblaze\u{2e}net\s+source\=IncrediFind\s+AgentHost\x3AHost\x3AHost\x3A\x2FGRSpynova3AFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.urlblaze.net") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "source=IncrediFind") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AgentHost:Host:Host:/GRSpynova3AFrom:\u{0a}"))))
; ^([0-1]?[0-9]|[2][0-3]):([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; /\/AES\d+O\d+\.jsp\?[a-z0-9=\u{2b}\u{2f}]{20}/iU
(assert (str.in_re X (re.++ (str.to_re "//AES") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iU\u{0a}"))))
; /Dr[.]?|Phd[.]?|MBA/i
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/Dr") (re.opt (str.to_re "."))) (re.++ (str.to_re "Phd") (re.opt (str.to_re "."))) (str.to_re "MBA/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
