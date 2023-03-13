(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; LIST\]SpamBlockerUtilityTry2FindBasicHost\x3AUser-Agent\x3AAcmeprotocolSpy
(assert (not (str.in_re X (str.to_re "LIST]SpamBlockerUtilityTry2FindBasicHost:User-Agent:AcmeprotocolSpy\u{0a}"))))
; /Referer\u{3a}\s*?http\u{3a}\u{2f}{2}[a-z0-9\u{2e}\u{2d}]+\u{2f}s\u{2f}\u{3f}k\u{3d}/Hi
(assert (not (str.in_re X (re.++ (str.to_re "/Referer:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "http:") ((_ re.loop 2 2) (str.to_re "/")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "/s/?k=/Hi\u{0a}")))))
(check-sat)
