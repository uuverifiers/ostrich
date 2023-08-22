(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; frame_ver2\s+communityLibrarySoftwareWinCrashcomHost\x3Atid\x3D\u{25}toolbar\x5Fid
(assert (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "communityLibrarySoftwareWinCrashcomHost:tid=%toolbar_id\u{0a}"))))
; ([0-9]{1,2}[:][0-9]{1,2}[:]{0,2}[0-9]{0,2}[\s]{0,}[AMPamp]{0,2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 0 2) (str.to_re ":")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.union (str.to_re "A") (str.to_re "M") (str.to_re "P") (str.to_re "a") (str.to_re "m") (str.to_re "p"))))))
(assert (> (str.len X) 10))
(check-sat)
