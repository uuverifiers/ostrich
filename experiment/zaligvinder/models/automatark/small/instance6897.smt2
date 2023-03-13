(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /sid=[0-9A-F]{32}/U
(assert (str.in_re X (re.++ (str.to_re "/sid=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/U\u{0a}"))))
; \x5BStatic\w+www\.iggsey\.comUser-Agent\x3AX-Mailer\u{3a}Computer
(assert (str.in_re X (re.++ (str.to_re "[Static") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.iggsey.comUser-Agent:X-Mailer:\u{13}Computer\u{0a}"))))
; /filename=[^\n]*\u{2e}sln/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sln/i\u{0a}"))))
; SpyAgent\s+daosearch\x2Ecom\s+X-Mailer\u{3a}\s+zmnjgmomgbdz\u{2f}zzmw\.gzt
(assert (not (str.in_re X (re.++ (str.to_re "SpyAgent") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "daosearch.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "zmnjgmomgbdz/zzmw.gzt\u{0a}")))))
(check-sat)
