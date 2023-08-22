(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; search\.dropspam\.com.*SupportFiles.*Referer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "search.dropspam.com") (re.* re.allchar) (str.to_re "SupportFiles\u{13}") (re.* re.allchar) (str.to_re "Referer:\u{0a}")))))
; ^([0-9A-Za-z@.]{1,255})$
(assert (str.in_re X (re.++ ((_ re.loop 1 255) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "@") (str.to_re "."))) (str.to_re "\u{0a}"))))
; frame_ver2\s+communityLibrarySoftwareWinCrashcomHost\x3Atid\x3D\u{25}toolbar\x5Fid
(assert (not (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "communityLibrarySoftwareWinCrashcomHost:tid=%toolbar_id\u{0a}")))))
; [0-3]{1}[0-9]{1}(jan|JAN|feb|FEB|mar|MAR|apr|APR|may|MAY|jun|JUN|jul|JUL|aug|AUG|sep|SEP|oct|OCT|nov|NOV|dec|DEC){1}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "3")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "jan") (str.to_re "JAN") (str.to_re "feb") (str.to_re "FEB") (str.to_re "mar") (str.to_re "MAR") (str.to_re "apr") (str.to_re "APR") (str.to_re "may") (str.to_re "MAY") (str.to_re "jun") (str.to_re "JUN") (str.to_re "jul") (str.to_re "JUL") (str.to_re "aug") (str.to_re "AUG") (str.to_re "sep") (str.to_re "SEP") (str.to_re "oct") (str.to_re "OCT") (str.to_re "nov") (str.to_re "NOV") (str.to_re "dec") (str.to_re "DEC"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
