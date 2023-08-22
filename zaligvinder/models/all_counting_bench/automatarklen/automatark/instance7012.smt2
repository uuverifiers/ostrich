(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^&]+&[a-z]=[a-f0-9]{16}&[a-z]=[a-f0-9]{16}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&") (re.range "a" "z") (str.to_re "=") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&") (re.range "a" "z") (str.to_re "=") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; /^\s*?MAIL\s+?FROM\u{3a}[^\r\n]*?\u{28}\u{29}\s\u{7b}/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MAIL") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "FROM:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "()") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "{/i\u{0a}")))))
; /\/[a-z]{1,4}\u{2e}html\u{3f}0\u{2e}[0-9]{15,}$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re ".html?0./U\u{0a}") ((_ re.loop 15 15) (re.range "0" "9")) (re.* (re.range "0" "9")))))
; \x2Fnewsurfer4\x2FOK\r\nencodertvlistingsTM_SEARCH3
(assert (not (str.in_re X (str.to_re "/newsurfer4/OK\u{0d}\u{0a}encodertvlistingsTM_SEARCH3\u{0a}"))))
; User-Agent\x3A\s+www\x2Emyarmory\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.myarmory.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
