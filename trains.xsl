<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes"/>

  <!-- ==================== ROOT TEMPLATE ==================== -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Train Trips Report</title>
        <style>
          @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&amp;family=Source+Sans+3:wght@400;600&amp;display=swap');

          * { box-sizing: border-box; margin: 0; padding: 0; }

          body {
            font-family: 'Source Sans 3', sans-serif;
            background: #f5f0e8;
            color: #1a1a2e;
            min-height: 100vh;
          }

          /* ---- HEADER ---- */
          .page-header {
            background: #1a1a2e;
            color: #f5f0e8;
            padding: 12px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            letter-spacing: 0.08em;
          }
          .page-header span { opacity: 0.7; }

          .hero {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 60%, #0f3460 100%);
            color: #f5f0e8;
            text-align: center;
            padding: 60px 40px 50px;
            position: relative;
            overflow: hidden;
          }
          .hero::before {
            content: "🚆";
            position: absolute;
            font-size: 200px;
            opacity: 0.04;
            top: -30px;
            right: -20px;
          }
          .hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.8rem;
            letter-spacing: 0.02em;
            margin-bottom: 10px;
          }
          .hero .subtitle {
            font-size: 1rem;
            opacity: 0.6;
            letter-spacing: 0.15em;
            text-transform: uppercase;
          }
          .hero .student-note {
            margin-top: 18px;
            display: inline-block;
            background: rgba(229,181,85,0.15);
            border: 1px solid rgba(229,181,85,0.4);
            color: #e5b555;
            padding: 6px 20px;
            border-radius: 30px;
            font-size: 0.82rem;
            letter-spacing: 0.06em;
          }

          /* ---- CONTAINER ---- */
          .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
          }

          /* ---- LINE CARD ---- */
          .line-card {
            background: #fff;
            border-radius: 12px;
            margin-bottom: 36px;
            box-shadow: 0 4px 24px rgba(26,26,46,0.09);
            overflow: hidden;
          }

          .line-header {
            background: linear-gradient(90deg, #1a1a2e 0%, #0f3460 100%);
            color: #f5f0e8;
            padding: 18px 28px;
            display: flex;
            align-items: center;
            gap: 14px;
          }
          .line-badge {
            background: #e5b555;
            color: #1a1a2e;
            font-weight: 700;
            font-size: 0.78rem;
            padding: 4px 12px;
            border-radius: 20px;
            letter-spacing: 0.08em;
          }
          .line-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.25rem;
          }
          .line-title .arrow { color: #e5b555; margin: 0 8px; }

          .line-body { padding: 24px 28px; }

          .section-label {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.14em;
            color: #e5b555;
            font-weight: 700;
            margin-bottom: 18px;
          }

          /* ---- TRIP BLOCK ---- */
          .trip-block {
            margin-bottom: 28px;
            border-left: 3px solid #e5b555;
            padding-left: 16px;
          }
          .trip-block:last-child { margin-bottom: 0; }

          .trip-title {
            font-size: 0.88rem;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
          }
          .trip-title .sep { color: #c0bdb4; }

          /* ---- TABLE ---- */
          table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.88rem;
          }
          thead tr {
            background: #1a1a2e;
            color: #f5f0e8;
          }
          thead th {
            padding: 10px 14px;
            text-align: center;
            font-weight: 600;
            letter-spacing: 0.06em;
            font-size: 0.8rem;
            text-transform: uppercase;
          }
          tbody tr { border-bottom: 1px solid #f0ece4; }
          tbody tr:last-child { border-bottom: none; }
          tbody tr:nth-child(even) { background: #faf7f2; }
          tbody td {
            padding: 10px 14px;
            text-align: center;
            color: #333;
          }

          .class-vip {
            color: #c0392b;
            font-weight: 700;
            letter-spacing: 0.05em;
          }
          .class-first { color: #2980b9; font-weight: 600; }
          .class-economy { color: #27ae60; }

          .price-cell { font-weight: 600; color: #1a1a2e; }

          /* ---- FOOTER ---- */
          footer {
            text-align: center;
            padding: 28px;
            font-size: 0.78rem;
            color: #999;
            letter-spacing: 0.06em;
          }
        </style>
      </head>
      <body>
        <div class="page-header">
          <span>UMBB – FS · CS Department</span>
          <span>Module: L3 - DSS · 2025/2026</span>
        </div>

        <div class="hero">
          <h1>Train Trips Report</h1>
          <div class="subtitle">Railway Trip Management System</div>
          <div class="student-note">
            TP_Do not copy directly / This page is implemented by the student : … name … / Group : …
          </div>
        </div>

        <div class="container">
          <xsl:apply-templates select="transport/line"/>
        </div>

        <footer>
          Generated by trains.xsl · UMBB CS Department · 2025/2026
        </footer>
      </body>
    </html>
  </xsl:template>

  <!-- ==================== LINE TEMPLATE ==================== -->
  <xsl:template match="line">
    <div class="line-card">
      <div class="line-header">
        <span class="line-badge"><xsl:value-of select="@id"/></span>
        <span class="line-title">
          <xsl:value-of select="@departure"/>
          <span class="arrow">→</span>
          <xsl:value-of select="@arrival"/>
        </span>
      </div>
      <div class="line-body">
        <div class="section-label">Detailed List of Trips:</div>
        <xsl:apply-templates select="trip"/>
      </div>
    </div>
  </xsl:template>

  <!-- ==================== TRIP TEMPLATE ==================== -->
  <xsl:template match="trip">
    <div class="trip-block">
      <div class="trip-title">
        Trip No. <xsl:value-of select="@id"/>
        <span class="sep">:</span>
        departureure: <xsl:value-of select="@departure"/>
        <span class="sep"> | </span>
        Arrival: <xsl:value-of select="@arrival"/>
      </div>
      <table>
        <thead>
          <tr>
            <th>Schedule</th>
            <th>Train Type</th>
            <th>Class</th>
            <th>Price (DA)</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="classes/class">
            <xsl:with-param name="departure_time" select="schedule/departure_time"/>
            <xsl:with-param name="arrival_time"   select="schedule/arrival_time"/>
            <xsl:with-param name="train_type"      select="train/@type"/>
          </xsl:apply-templates>
        </tbody>
      </table>
    </div>
  </xsl:template>

  <!-- ==================== CLASS ROW TEMPLATE ==================== -->
  <xsl:template match="class">
    <xsl:param name="departure_time"/>
    <xsl:param name="arrival_time"/>
    <xsl:param name="train_type"/>
    <tr>
      <td>
        <xsl:value-of select="$departure_time"/> - <xsl:value-of select="$arrival_time"/>
      </td>
      <td><xsl:value-of select="$train_type"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="@name = 'VIP'">
            <span class="class-vip">VIP</span>
          </xsl:when>
          <xsl:when test="@name = 'First'">
            <span class="class-first">First</span>
          </xsl:when>
          <xsl:otherwise>
            <span class="class-economy"><xsl:value-of select="@name"/></span>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="price-cell"><xsl:value-of select="@price"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
