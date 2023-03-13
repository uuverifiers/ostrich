(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/html\/license_[0-9A-F]{550,}\.html$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//html/license_.html/Ui\u{0a}") ((_ re.loop 550 550) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F")))))))
; ^([0-9a-fA-F])*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}")))))
; frame_ver2\s+www\u{2e}urlblaze\u{2e}net\s+source\=IncrediFind\s+AgentHost\x3AHost\x3AHost\x3A\x2FGRSpynova3AFrom\x3A
(assert (not (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.urlblaze.net") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "source=IncrediFind") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AgentHost:Host:Host:/GRSpynova3AFrom:\u{0a}")))))
; ('((\\.)|[^\\'])*')
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}'") (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (str.to_re "\u{5c}") (str.to_re "'"))) (str.to_re "'")))))
; /filename=[^\n]*\u{2e}maplet/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".maplet/i\u{0a}"))))
(check-sat)
