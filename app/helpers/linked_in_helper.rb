module LinkedInHelper
  def linked_in_url(cert)
    cert_name = URI.encode(cert.course.title)
    cert_lic_no = URI.encode(cert.licence_number)
    cert_start = URI.encode(cert.created_at.strftime "%Y%m")
    cert_url = URI.encode(certificate_url(cert.licence_number, format: "pdf"))
    "http://www.linkedin.com/profile/add?_ed=0_7nTFLiuDkkQkdELSpruCwH_U6KgJ_h-Q7dihvLOc4XajThE8H-fiVUJBGpBJy3EUaSgvthvZk7wTBMS3S-m0L6A6mLjErM6PJiwMkk6nYZylU7__75hCVwJdOTZCAkdv&pfCertificationName=#{cert_name}&pfLicenseNo=#{cert_lic_no}&pfCertStartDate=#{cert_start}&pfCertificationUrl=#{cert_url}"
  end
end
