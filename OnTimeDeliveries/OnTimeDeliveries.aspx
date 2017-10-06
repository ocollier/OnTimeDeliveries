<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OnTimeDeliveries.aspx.cs" Inherits="OnTimeDeliveries" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>On Time Deliveries</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous"/>
    <style type="text/css">
        .form-control{
            display: inline-block;
        }
        fieldset {
            padding: 5px;
        }
        @media print {
          .hidden-print {
            display: none !important;
          }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="col-md-6">
                <asp:Panel ID="pnlAddDelivery" runat="server" CssClass="mb-5">
                    <fieldset>
                        <legend>Add Delivery</legend>
                        <p>Please add at least 5 Deliveries and use at least 2 different Vehicle Types.</p>
                        <div class="form-group col-md-12">
                            <label class="control-label col-md-2" for="txtDepartTime">Depart Time:</label>
                            <asp:TextBox CssClass="form-control col-md-2" ID="txtDepartTime" runat="server" type="time" required/>
                            <div class="invalid-feedback col-md-12">
                                Invalid Depart Time. Please enter as a time.
                            </div>
                        </div>
                        <div class="form-group col-md-12">
                            <label class="control-label col-md-2" for="txtDistance">Distance:</label>
                            <asp:TextBox CssClass="form-control col-md-2" ID="txtDistance" placeholder="Enter Distance" runat="server" type="number" min="1" required/>
                            <div class="invalid-feedback col-md-12">
                                Invalid Distance. Must be a numberic value, greater than 0.
                            </div>
                        </div>
                        <div class="form-group col-md-12">
                            <label class="control-label col-md-2" for="ddlVehicleType">Vehicle Type:</label>
                            <asp:DropDownList CssClass="form-control col-md-3" ID="ddlVehicleType" DataTextField="VehicleType" DataValueField="MilesPerHour" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVehicleType_SelectedIndexChanged" required/>
                            <label class="control-label col-md-2" for="ddlVehicleType" id="lblVehicleMileage" runat="server"></label>
                            <div class="invalid-feedback col-md-4">
                                Vehicle Type is required.
                            </div>
                        </div>
                        <div class="form-group col-md-12">
                            <label class="control-label col-md-2"></label>
                            <asp:Button CssClass="btn btn-secondary" ID="btnCalulateTravelTime" Text="Calulate Travel Time" runat="server" OnClick="btnCalulateTravelTime_Click"/>
                        </div>
                        <div class="form-group col-md-12">
                            <label class="control-label col-md-2" for="txtTravelTime">Travel Time:</label>                    
                            <input class="form-control col-md-2" type="text" id="txtTravelTime" runat="server" readonly="true" />
                        </div>
                        <div style="display:none;" class="form-group col-md-12">
                            <label class="control-label col-md-2" for="txtDeliveryTime">Delivery Time:</label>                    
                            <input class="form-control col-md-2" type="text" id="txtDeliveryTime" runat="server" readonly="true" />
                        </div>
                        <asp:Button CssClass="btn btn-primary" ID="btnAddDelivery" Text="Add" runat="server" OnClick="btnAddDelivery_Click" Visible="false" />
                    </fieldset>
                </asp:Panel>
                <asp:Panel ID="pnlDeilverySchedule" runat="server" Visible="false">
                    <fieldset>
                        <legend>Delivery Schedules</legend>
                        <asp:ListView ID="lvDeliverySchedule" runat="server" ItemPlaceholderID="itemPlaceHolder1">
                            <LayoutTemplate>
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Tracking Number</th>
                                            <th>Departure Date/Time</th>
                                            <th>Vehicle Type</th>
                                            <th>Travel Distance</th>
                                            <th>Travel Time</th>
                                            <th>Delivery Date/Time</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:PlaceHolder runat="server" ID="itemPlaceHolder1"></asp:PlaceHolder>
                                    </tbody>
                                </table>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%#Eval("TrackingNumber") %></td>
                                    <td><%#Eval("DepartureTime", "{0:MM/dd/yyyy hh:mm tt}") %></td>
                                    <td><%#Eval("VehicleType") %></td>
                                    <td><%#Eval("TravelDistance") %></td>
                                    <td><%# String.Format("{0:0.00 Hours}", Eval("TravelTime")) %></td>
                                    <td><%#Eval("DeliveryTime", "{0:MM/dd/yyyy hh:mm tt}") %></td>
                                    <td><asp:Button CssClass="btn btn-default hidden-print" ID="btnDeleteDelivery" Text="Delete" runat="server" OnClick="btnDeleteDelivery_Click" CommandArgument='<%#Eval("TrackingNumber")%>' formnovalidate/></td>
                                </tr>                            
                            </ItemTemplate>
                        </asp:ListView>
                        <asp:Button CssClass="btn btn-primary" ID="btnShowSchedule" Text="Show Schedule" runat="server" OnClick="btnShowSchedule_Click" formnovalidate Visible="false" />
                        <asp:Button CssClass="btn btn-primary hidden-print" ID="btnAddMoreDeliveries" Text="Add More Deliveries" runat="server" OnClick="btnAddMoreDeliveries_Click" Visible="false" />
                        <asp:Label ID="lblShowScheduleMsg" runat="server" CssClass="invalid-feedback col-md-12" />
                    </fieldset>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>