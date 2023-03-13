(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; frame_ver2\s+communityLibrarySoftwareWinCrashcomHost\x3Atid\x3D\u{25}toolbar\x5Fid
(assert (not (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "communityLibrarySoftwareWinCrashcomHost:tid=%toolbar_id\u{0a}")))))
; www\x2Eemp3finder\x2Ecom\d+ZOMBIES\u{5f}HTTP\u{5f}GET
(assert (str.in_re X (re.++ (str.to_re "www.emp3finder.com") (re.+ (re.range "0" "9")) (str.to_re "ZOMBIES_HTTP_GET\u{0a}"))))
; ^[a-zA-Z]{4}\d{6}[a-zA-Z]{6}\d{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}png/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".png/i\u{0a}"))))
; /\/stat_svc\/$/U
(assert (str.in_re X (str.to_re "//stat_svc//U\u{0a}")))
(check-sat)
