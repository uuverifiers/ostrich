(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; sponsor2\.ucmore\.com\s+informationHost\x3A\x2Fezsb
(assert (str.in_re X (re.++ (str.to_re "sponsor2.ucmore.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "informationHost:/ezsb\u{0a}"))))
; User-Agent\x3AUser-Agent\x3Awp-includes\x2Ftheme\x2Ephp\x3Fframe_ver2
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:wp-includes/theme.php?frame_ver2\u{0a}"))))
; (\d{1,2}(\:|\s)\d{1,2}(\:|\s)\d{1,2}\s*(AM|PM|A|P))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re ":") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re ":") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 2) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "AM") (str.to_re "PM") (str.to_re "A") (str.to_re "P")))))
; SI\|Server\|\s+OSSProxy\x5Chome\/lordofsearch%3fAuthorization\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "SI|Server|\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OSSProxy\u{5c}home/lordofsearch%3fAuthorization:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
